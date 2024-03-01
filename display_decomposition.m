%% A `.m' variant of the live script display_decomposition.mlx %%

% This sheet displays an already computed Series-FSD
% The Series-FSD should be stored in variables with the following names:
%  - partitions: l_part_A r_part_A l_part_B r_part_B
%  - `outer' bases matrices: left_A core_Q l_part_B core_B r_part_B
%  - (optional) `inner' bases matrices: right_A left_B
%  - core matrices: core_A core_Q core_B 
% Enjoy!
%---------------------------------------%

% warning: displayed variables have rounded entries
left_A_disp = as_partitioned_only_cols(left_A, l_part_A) % `left outer' basis (left of A)
core_A_disp = as_partitioned(l_part_A, core_A, r_part_A) % representative of A
core_Q_disp = as_partitioned(r_part_A, core_Q, l_part_B) % ``adapter matrix from A to B'' - representative of the identity matrix
core_B_disp = as_partitioned(l_part_B, core_B, r_part_B) % representative of B
right_B_disp = as_partitioned_only_cols(right_B, r_part_B) % `right outer' basis (right of B)

% (optional) display inner bases
% 2nd from the left (right of A and left of Q)
right_A_disp = as_partitioned(r_part_A, right_A, l_part_B)
% 3nd from the left (right of Q and left of B)
left_B_disp = as_partitioned(l_part_B, left_B, r_part_A)


