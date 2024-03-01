% Function apply_step (currently out of use).
function   [core_left, ...
            partition_left, ...
            basis_left, ...
            core_parent, ...
            partition_right, ...
            basis_right, ...
            core_right]...
        = ...
            apply_step(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                core_left, ...
                partition_left, ...
                basis_left, ...
                core_parent, ...
                partition_right, ...
                basis_right, ...
                core_right ...
    )
% Apply (two-sided) step of triggering a block. 
% Essentially function cell_apply_step but without wrapping bases and cores
% in cells.

%% INPUT/OUTPUT %%
% Input and output variables are mostly identical,
% with input having additionally block-indices i,j that indicate the
% triggered block.
% Input variables hold values before applying the step, 
% and output variables hold values after applying the step.
%
% Variables description:
% partition_left: partition between triggered parent and left neighbor
% partition_right: partition between triggered parent and right neighbor
% core_parent: triggered parent core matrix
% core_left: left neighbor core matrix
% core_right: right neighbor core matrix
% basis_left: basis between triggered parent and left neighbor
% basis_right: basis between triggered parent and right neighbor
%
%-------------------------------------------------------------------%

%% Get triggered block
% (actual) row indices of the triggered block
i1 = partition_left(i)
i2 = partition_left(i+1) - 1
% (actual) column indices of the triggered block
j1 = partition_right(j)
j2 = partition_right(j+1) - 1
% get triggered block (T)
triggered_block = core_parent(i1:i2, j1:j2)

% alias
T = triggered_block



%%% process triggered block
%% get bases updates (out of svd of triggered block)
%% and partition update (out of numrank of block)
% get bases updates
[U_T, sigma_T_vec, V_T] = svd(T, "vector")
% numrank - used only for partition
numrank_T = sum(sigma_T_vec > tol_numrank) % number of ``numerically'' nonnegligible singvals
% build Sigma matrix
Sigma_T = diag(sigma_T_vec)


%%% apply bases updates and partition updates
%% parent: act by left basis
    % update left partition
        % partition i-th block-row into (numrank, ~) (will automatically induce
        % partition in left neighbor block-columns)
partition_left = [partition_left(1:i), partition_left(i) + numrank_T, partition_left((i+1):size(partition_left, 2))]
    % affect parent
        % parent %
        % lmult i-th block-row by U_T'
core_parent(i1:i2, :) = U_T' * core_parent(i1:i2, :)
    % affect left neighbor:
        % left neighbor %
        % rmult i-th block-column by U_T
core_left(:, i1:i2) = core_left(:, i1:i2) * U_T
    % affect left basis
        % left basis %
        % rmult i-th block-column by U_T
basis_left(:, i1:i2) = basis_left(:, i1:i2) * U_T;
%% parent: act by right basis
    % update right partition
        % partition j-th block-column into (numrank, ~)(will automatically induce
        % partition in right neighbor block-rows)
partition_right = [partition_right(1:j), partition_right(j) + numrank_T, partition_right((j+1):size(partition_right, 2))]
    % affect parent
        % parent %
        % rmult j-th block-column by V_T
core_parent(:, j1:j2) = core_parent(:, j1:j2) * V_T
        % (the triggered block obtains value Sigma_T)
    % affect right neighbor
        % right neighbor %
        % lmult j-th block-row by V_T'
core_right(j1:j2, :) = V_T' * core_right(j1:j2, :)
    % affect right basis
        % right basis %
        % rmult j-th block-column by V_T % 
            % Comment: (we update right basis 
            % by rmult j-th block-column by V_T, not lmult j-th block-row by V' because 
            % the invariant is 
            %   Parent * basis_right' = const.
            % So we actually keep the conjT of the factor of the invariant,
            % and so in 'conjT'-notation it is still lmult by V_T' as it should be,
            % i.e. 
            %   basis_right'(J, :) = V_T' * basis_right'(J, :)
            % End of Comment
basis_right(:, j1:j2) = basis_right(:, j1:j2) * V_T;

end