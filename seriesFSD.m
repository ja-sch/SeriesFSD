function [...
        left_A, ... 
        l_part_A, ...
        core_A, ...
        r_part_A, ...
        right_A, ...
        core_Q, ...
        left_B, ...
        l_part_B, ...
        core_B, ...
        right_B, ...
        r_part_B ...
        ]...
= seriesFSD(A, B, tol_numrank)
% This function does Series-FSD of a pair of matrices (A,B).
%
% Input: 
%   A, B: matrices such that their product A*B is well-defined
%   tol_numrank: 
%       tolerance for computing numerical rank (should be smaller
%       than singular values of the to-be obtained blocks, but larger than the
%       `artificially nonzero' singular values that mathematically are actually
%       zero). A global setting.
% Output: Series-FSD of pair of matrices (A,B):
% %       left_A: matrix -- left basis of A.
%         l_part_A: matrix -- left partition of A.
%         core_A: : matrix -- core of A.
%         r_part_A: matrix -- right partition of A.
%         right_A: matrix -- right basis of A.
%         core_Q: matrix -- core of Q.
%         left_B: matrix -- left basis of B.
%         l_part_B: matrix -- left partition of B.
%         core_B: : matrix -- core of B.
%         r_part_B: matrix -- right partition of B.
%         right_B: matrix -- right basis of B.
%
% Limitations: the decomposition is computed correctly but 
% displaying trivial dimensions works only for block-columns 
% (for more detail see documentation of function seriesFSD)
% Comment: There are no trivial dimensions if and only if
% the input satisfies the following condition:
    % For input pair of matrices (A,B) of dimensions denoted as m,n,p, that is:
    %   A: m x n matrix,
    %   B: n x p matrix,
    % the following integers, which always are nonnegative, are positive:
    %   rank(AB),
    %   rank(A) - rank(AB),
    %   m - rank(A) ,
    %   rank(B) - rank(AB),
    %   p-rank(B),
    %   n-rank(B) + rank(AB) % is implied by rank(AB)>0 but let's keep it,
    %   n-rank(A) + rank(AB) % is implied by rank(AB)>0 but let's keep it.

%%%% About the algorithm and this implementation %%%%
%% Factorization %%
% The algorithm transforms a factorization step by step.
% A factorization is a triple of matrices (A,Q,B) whose dimensions agree 
% so that the product A Q B is well-defined.

%% Bases %%
% Every mapping - A, Q, B - is surrounded by two bases, left and right.
% Bases must be orthonormal.
% Some bases are shared by mappings:
%   A and Q share base (A right = Q left), and  
%   Q and B share base (Q right = B left).
% Every mapping, as is often done in linear algebra, is decomposed as 
%    its ''core'' matrix (also called representative)
%    and two matrices that represent its **left and right base**.
% Throughout the algorithm, bases and core will change, but the mapping
% will not change. 
% For example, mapping A can always be retrieved by:
%   A = left_A * core_A * right_A' (notice conjugate transposition on the right)

%% Step %%
% Every step transforms the factorization to another triple of matrices by
% changing one of the bases (change of base must be unitary).
% The factorization initial configuration is A Q B 
% where Q is (initially) an identity matrix.
% After each step, we will retain 
% the original linear mappings A I B but in different bases, 
% as explained in more detail below.

%% Partitions %%
% All matrices are partitioned so they are block matrices and the
% partitions
% are shared among the neighboring factors in a factorization: 
% for example, the basis matrix left_A shares partition with matrix A 
% (right (i.e. column) partition of matrix left_A 
% = left (i.e. row) partition of matrix A)

%% Goal %%
% Goal of the algorithm: modify the bases so that
% the core of each mappings A, B, and A*B is in the desired form, which we called
% 'fundamental spaces decomposition' 
% (see the theory page for % more about motivation and applications).

%%%% End of: About the algorithm and this implementation %%%%

%----------------------------------------%

% Input validation
assert(size(A, 2) == size(B, 1))


%%%% Run implementation %%%%
%%% Initial configuration
% Initialize cores and bases (both left and right)
% A
left_A = eye(size(A, 1));
core_A = A;
right_A = eye(size(A, 2));
% B
left_B = eye(size(B, 1));
core_B = B;
right_B = eye(size(B, 2));
% Q
core_Q = eye(size(A, 2));
% left_Q is identified with right_A, and
% right_Q is identified with left_A

% initialize partitions of A and B
l_part_A = [1, size(A, 1) + 1];
r_part_A = [1, size(A, 2) + 1];
l_part_B = [1, size(B, 1) + 1];
r_part_B = [1, size(B, 2) + 1];

% comment: notice that Q is not part of the input
%%% STEPS %%%
%% STEP 1 %%
% Trigger A

% define step
% mapping:
%   A
% block-indices:
i = 1;
j = 1;
%------------------------------%

% apply step
[l_part_A,    ... partition_left
left_A,    ... basis_left
core_A,    ... core_parent
r_part_A,  ...  partition_right
right_A,    ... basis_right
core_Q      ... core_right
] ...
= ...
apply_step_only_right_neighbors( ...
i, ...
j, ...
tol_numrank, ...
l_part_A,    ... partition_left
left_A,    ... basis_left
core_A,    ... core_parent
r_part_A,  ...  partition_right
right_A,    ... basis_right
core_Q      ... core_right
);

%% STEP 2 %%
% Trigger B %

% define step
% mapping:
    % B
% block-indices:
i = 1;
j = 1;
%------------------------------%

% apply step
[core_Q,    ... core_left
l_part_B,    ... partition_left
left_B,    ... basis_left
core_B,    ... core_parent
r_part_B,  ...  partition_right
right_B    ... basis_right
] ...
= ...
apply_step_only_left_neighbors( ...
i, ...
j, ...
tol_numrank, ...
core_Q,    ... core_left
l_part_B,    ... partition_left
left_B,    ... basis_left
core_B,    ... core_parent
r_part_B,  ...  partition_right
right_B    ... basis_right
);


%% STEP 3 %%
% Trigger Q_11 %

% define step
% mapping: 
    % Q
% block-indices:
i = 1;
j = 1;
%------------------------------%

% apply step
[core_A,    ... core_left
r_part_A,    ... partition_left
right_A,    ... basis_left
core_Q,    ... core_parent
l_part_B,  ...  partition_right
left_B,    ... basis_right
core_B]    ... core_right
= ...
apply_step_two_neighbors( ...
i, ...
j, ...
tol_numrank, ...
core_A,    ... core_left
r_part_A,    ... partition_left
right_A,    ... basis_left
core_Q,    ... core_parent
l_part_B,  ...  partition_right
left_B,    ... basis_right
core_B   ... core_right...
);


%% STEP 4 %%
% Trigger A_11_1 - LEFT-ONLY TRIGGER %

% define step
% mapping:
    % A
% block-indices:
i = 1;
j = 1;
% trigger type: LEFT-ONLY
% triggered block property: full-rank tall )

% comment: again step is (mapping A, indices (i,j) = (1,1)) but now it represents a different block
%------------------------------%

% apply step
[l_part_A,    ... partition_left
left_A,    ... basis_left
core_A    ... core_parent
] ...
= ...
apply_left_step_no_neighbor( ...
i, ...
j, ...
tol_numrank, ...
l_part_A,    ... partition_left
left_A,    ... basis_left
core_A,    ... core_parent
r_part_A  ...  partition_right
);

%% STEP 5 %%
% Trigger B_11_1 - RIGHT-ONLY TRIGGER (modify cols)

% define step
% mapping:
    % B
% block-indices:
i = 1;
j = 1;
% trigger type: RIGHT-ONLY
% triggered block property: full rank wide
% comment: again mapping B and indices (i,j) = (1,1) but now it represents a different block
%------------------------------%

% apply step
            [core_B, ... core_parent 
            r_part_B, ... partition_right
            right_B... basis_right
            ] ...
        = ...
            apply_right_step_no_neighbor(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                l_part_B, ... partition_left
                core_B, ... core_parent
                r_part_B, ... partition_right
                right_B... basis_right 
    );
%%%~~~%%%
% FURTHER DECOMPOSE Q (without affecting A or B 'morally speaking', as all
% affected blocks are 0, so in both steps we use the `no-neighbor' updates) %
%%%~~~%%%
%% STEP 6 %%
% Q: (3,2) block (full rank tall) LEFT-ONLY TRIGGER 

% define step
% mapping:
    % Q
% block-indices:
i = 3;
j = 2;
% 
% trigger type: LEFT-ONLY
% triggered block property: full rank tall
% comment: we apply the `no-neighbor' variant because the
% affected blocks of the left neighbor are 0
%------------------------------%

% apply step
[r_part_A,    ... partition_left
right_A,    ... basis_left
core_Q    ... core_parent
] ...
= ...
apply_left_step_no_neighbor( ...
i, ...
j, ...
tol_numrank, ...
r_part_A,    ... partition_left
right_A,    ... basis_left
core_Q,    ... core_parent
l_part_B  ...  partition_right
);

%% STEP 7 %%
% Q: (2,3) block (full rank wide) RIGHT-ONLY TRIGGER

% define step
% mapping:
    % Q
% block-indices:
i = 2;
j = 3;
% 
% trigger type: RIGHT-ONLY
% triggered block property: full rank wide
% comment: we apply the `no-neighbor' variant because the
% affected blocks the right neighbor are 0
%------------------------------%

% apply step
[core_Q, ... core_parent 
            l_part_B, ... partition_right
            left_B... basis_right
            ] ...
        = ...
            apply_right_step_no_neighbor(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                r_part_A, ... partition_left
                core_Q, ... core_parent 
                l_part_B, ... partition_right
                left_B... basis_right
    );

end