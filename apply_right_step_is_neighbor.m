% Function apply_right_step_is_neighbor.
function   [core_parent, ...
            partition_right, ...
            basis_right, ...
            core_right]...
        = ...
            apply_right_step_is_neighbor(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                partition_left, ...
                core_parent, ...
                partition_right, ...
                basis_right, ...
                core_right ...
    )
% Apply (one-sided right) step of triggering a block that has a right neighbor.
% Input requirement: 
%   triggered block is *nonsquare* full-rank wide,    
%   parent mapping has a right neighbor.

% Essentially does the same as function apply_step_two_neighbors but has
% less i/o variables (the redundant - i.e. all left-side - has been removed).
% Read documentation of function apply_step_two_neighbors for more info.

%-------------------------------------------------------------------%

% pack neighbors and bases into cells
Bases_left = {} % dummy variable (one-sided right trigger)
Cores_left = {} % dummy variable (one-sided right trigger)
Cores_right = {core_right}
Bases_right = {basis_right}


% apply step
[~, ... Cores_left
            ~, ... partition_left
            ~, ... Bases_left
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
                false, ... apply_update_to_left_side_indicator
                true, ... apply_update_to_right_side_indicator
                false, ... full_rank_tall_validation_indicator
                true ... full_rank_wide_validation_indicator
    )
% unpack neighbors and bases from cells
% [no action] one-sided right trigger
core_right = Cores_right{1}
% [no action] one-sided right trigger
basis_right = Bases_right{1}

end