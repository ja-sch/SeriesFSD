% Function essentially same as function apply_step but some input arguments
% and some output values (strictly more than input arguments: also
% partition variables) are packed in cells.
function   [Cores_left, ...
            partition_left, ...
            Bases_left, ...
            core_parent, ...
            partition_right, ...
            Bases_right, ...
            Cores_right]...
        = ...
            cell_apply_step(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                Cores_left, ...
                partition_left, ...
                Bases_left, ...
                core_parent, ...
                partition_right, ...
                Bases_right, ...
                Cores_right, ...
                apply_update_to_left_side_indicator, ...
                apply_update_to_right_side_indicator, ...
                full_rank_tall_validation_indicator, ...
                full_rank_wide_validation_indicator ...
    )
% Apply (two-sided) step of triggering a block.

%% INPUT/OUTPUT %%
% Input and output variables are mostly identical,
% with input having additionally block-indices i,j that indicate the
% triggered block.
% Input variables hold values before applying the step, 
% and output variables hold values after applying the step.
%
% Variables description:
% partitions:
    % partition_left: partition between triggered parent and left neighbor
    % partition_right: partition between triggered parent and right neighbor
% matrix cores:
    % core_parent: triggered parent core matrix
    % Cores_left: cell of core matrices of left neighbors (in current use has size 0
    % or 1)
    % Cores_right: cell of core matrices of right neighbors (in current use has size 0
    % or 1)
% bases:
    % Bases_left: cell of at most one element, if nonempty then holds the basis between triggered parent and left neighbor
    % Bases_right: cell of at most one element, if nonempty then holds the basis between triggered parent and right neighbor

%-------------------------------------------------------------------%


%% Input validation
assert(size(Bases_left, 2) <= 1, "There can be at most one left basis but " + string(size(Bases_left, 2)) + " were given.")
assert(size(Bases_right, 2) <= 1, "There can be at most one right basis but " + string(size(Bases_right, 2)) + " were given.")
assert(apply_update_to_left_side_indicator | apply_update_to_right_side_indicator, "Wrong indicator values: at least one side has to be updated (during the step).")

%% Get triggered block
% (actual) row indices of the triggered block
i1 = partition_left(i);
i2 = partition_left(i+1) - 1;
% (actual) column indices of the triggered block
j1 = partition_right(j);
j2 = partition_right(j+1) - 1;
% get triggered block (T)
triggered_block = core_parent(i1:i2, j1:j2);

% alias
T = triggered_block;



%%% process triggered block
%% get bases updates (out of svd of triggered block)
%% and partition update (out of numrank of block)
% get bases updates
[U_T, sigma_T_vec, V_T] = svd(T, "vector");
% numrank - used only for partition
numrank_T = sum(sigma_T_vec > tol_numrank); % number of ``numerically'' nonnegligible singvals
% for the reference, ``imaginarily'' build Sigma matrix
% Sigma_T = diag(sigma_T_vec)

%% validate triggered block non-square full-rank conditions

if full_rank_tall_validation_indicator
    % check if T is full rank tall
%     assert(size(T, 1) ~= size(T, 2)) % no need to assert non-squareness, if it does
%     not hold then simply a trivial dimension will occur
    assert(numrank_T == size(T, 2), "Triggered block should be (as required by the indicator) full-rank tall. Numerical rank of the block: " + ...
        string(numrank_T) + ", number of columns: " + string(size(T, 2)) + ".")
end

if full_rank_wide_validation_indicator
    % check if it is full rank wide
%     assert(size(T, 1) ~= size(T, 2)) % no need to assert non-squareness, if it does
%     not hold then simply a trivial dimension will occur
    assert(numrank_T == size(T, 1), "Triggered block should be (as required by the indicator) full-rank wide. Numerical rank of the block: " + ...
        string(numrank_T) + ", number of rows: " + string(size(T, 1)) + ".")
end

%%% apply bases updates and partition updates
if apply_update_to_left_side_indicator
    %% parent: act by left basis
        % update left partition
            % partition i-th block-row into (numrank, ~) (will automatically induce
            % partition in left neighbor block-columns)
    partition_left = [partition_left(1:i), partition_left(i) + numrank_T, partition_left((i+1):size(partition_left, 2))];
        % affect parent
            % parent %
            % lmult i-th block-row by U_T'
    core_parent(i1:i2, :) = U_T' * core_parent(i1:i2, :);
        % affect left neighbor:
            % left neighbor %
            % rmult i-th block-column by U_T
    for i=1:size(Cores_left,2)
        core_left = Cores_left{1};
        core_left(:, i1:i2) = core_left(:, i1:i2) * U_T;
        Cores_left{1} = core_left;
    end
        % affect left basis
            % left basis %
            % rmult i-th block-column by U_T
    for i=1:size(Bases_left,2)
        basis_left = Bases_left{i};
        basis_left(:, i1:i2) = basis_left(:, i1:i2) * U_T;
        Bases_left{i} = basis_left;
    end
end
if apply_update_to_right_side_indicator
    %% parent: act by right basis
        % update right partition
            % partition j-th block-column into (numrank, ~)(will automatically induce
            % partition in right neighbor block-rows)
    partition_right = [partition_right(1:j), partition_right(j) + numrank_T, partition_right((j+1):size(partition_right, 2))];
        % affect parent
            % parent %
            % rmult j-th block-column by V_T
    core_parent(:, j1:j2) = core_parent(:, j1:j2) * V_T;
            % (the triggered block obtains value Sigma_T)
        % affect right neighbor
            % right neighbor %
            % lmult j-th block-row by V_T'
    for i=1:size(Cores_right,2)
        core_right = Cores_right{i};
        core_right(j1:j2, :) = V_T' * core_right(j1:j2, :);
        Cores_right{i} = core_right;
    end
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
    for i=1:size(Bases_right,2)
        basis_right = Bases_right{i};
        basis_right(:, j1:j2) = basis_right(:, j1:j2) * V_T;
        Bases_right{i} = basis_right;
    end
end
end