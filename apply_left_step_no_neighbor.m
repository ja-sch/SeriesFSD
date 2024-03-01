% Function apply_left_step_no_neighbor.
function   [partition_left, ...
            basis_left, ...
            core_parent ...
            ]...
        = ...
            apply_left_step_no_neighbor(...
                i, ...      % triggered block block-coordinates: row
                j, ...      % triggered block block-coordinates: column
                tol_numrank, ...
                partition_left, ...
                basis_left, ...
                core_parent, ...
                partition_right ...
    )
% Apply (one-sided left) step of triggering a block that does not have a left neighbor.
% Input requirement: 
%   triggered block is *nonsquare* full-rank tall,    
%   parent mapping does not have a left neighbor.

% Essentially does the same as function apply_step_two_neighbors but has
% less i/o variables (the redundant - i.e. all right-side, core of left neighbor - has been removed).
% Read documentation of function apply_step_two_neighbors for more info.

%-------------------------------------------------------------------%

% pack neighbors and bases into cells
Cores_left = {}; % no left neighbor
Bases_left = {basis_left};
Bases_right = {}; % dummy variable (one-sided left trigger)
Cores_right = {}; % dummy variable (one-sided left trigger)

% apply step
%
% Cores_left, ...
%             partition_left, ...
%             Bases_left, ...
%             core_parent,
%
[~, ...
            partition_left, ...
            Bases_left, ...
            core_parent, ...
            ~, ...
            ~, ...
            ~]...
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
                true, ... apply_update_to_left_side_indicator
                false, ... apply_update_to_right_side_indicator
                true, ... full_rank_tall_validation_indicator
                false ... full_rank_wide_validation_indicator
    );
% unpack neighbors and bases from cells
% [no action] no left neighbor
% [no action] one-sided left trigger
basis_left = Bases_left{1};
% [no action] one-sided left trigger

end