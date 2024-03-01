function [result] = as_partitioned_only_cols(M, r_part_M)
% Displays matrix M in block form,
% with columns partitioned by r_part_M.
% no partition of rows, in the sense that there is a single row block.
% Columns have names (generic, `in'+ number, where `in' stands for `input').
%
% Warning: rounds entries for display clarity!!!
%
% Similar to function as_partitioned -- see its documentation for more
% details.

%% Round entries for display clarity
M = round(M, 2);

%% prepare
% get numbers of blocks in rows and columns
ncol = size(r_part_M, 2) - 1;

% create empty table
my_table = table();

%% do function
for j=1:ncol
    j1 = r_part_M(j);
    j2 = r_part_M(j+1) - 1;
    % hconcat next block of columns 
    my_table = addvars(my_table, M(:, j1:j2) ...
    ,'NewVariableNames','blk_col_' + string(j));
end

%% return result
result = my_table;
end