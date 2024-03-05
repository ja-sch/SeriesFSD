%%%% TEST SUBSPACES
%%%% We verify the paper's way of computing the subspaces.
%%%% We verify the paper's formula for the spaces spanned by blocks of bases matrices.
%%%% We do it for matrix A, both left and right basis.
%%%% We verify all except the last basis, as the result follows by
%%%% orthogonal complement.
%%%% We verify only A, because B is dual (if the way of computing
%%%% the subspaces worked for A, then most probably it is a correct one.
%%%% Also, then definitely the analogous formulas work for B.

%%%% TODO: verify subspaces for Q

%%% (Optional) Clear environment
% Clear environment, leave only ``main script output'' variables:
% 
% partitions: l_part_A r_part_A l_part_B r_part_B
% `outer' bases matrices: left_A core_Q l_part_B core_B r_part_B
% (optional) `inner' bases matrices: right_A left_B
% core matrices (representatives of 
% input matrix A, identity matrix, input matrix B
% in the changed bases): core_A core_Q core_B
%

%---- Uncomment below line to clear the environment ----%
% clearvars -except l_part_A left_A core_A right_A r_part_A core_Q l_part_B left_B core_B right_B r_part_B


%%% global setting tolerance
tol = 1e-12

%%%% TESTS %%%%

%%% A: first block, left basis %%%
i = 1; % index of tested block
tested_subspace_matrix = A * B;
% get block indices
i1 = l_part_A(i);
i2 = l_part_A(i+1) - 1;
% do test
test_colspace_equality(left_A(:, i1:i2), tested_subspace_matrix, tol)

%%% A: first block, right basis %%%
i = 1; % index of tested block
tested_subspace_matrix = pinv(A) * A * B;
% get block indices
i1 = r_part_A(i);
i2 = r_part_A(i+1) - 1;
% do test
test_colspace_equality(right_A(:, i1:i2), tested_subspace_matrix, tol)

%%% A: first two blocks, left basis %%%
i = 1; % index of tested block
tested_subspace_matrix = A;
% get block indices
i1 = l_part_A(i);
i2 = l_part_A(i+2) - 1;
% do test
test_colspace_equality(left_A(:, i1:i2), tested_subspace_matrix, tol)

%%% A: first two blocks, right basis %%%
i = 1; % index of tested block
tested_subspace_matrix = A';
% get block indices
i1 = r_part_A(i);
i2 = r_part_A(i+2) - 1;
% do test
test_colspace_equality(right_A(:, i1:i2), tested_subspace_matrix, tol)

