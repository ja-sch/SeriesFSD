function [result] = as_partitioned(l_part_M, M, r_part_M)
% Displays matrix M in block form,
% with rows partitioned by l_part_m and 
% columns partitioned by r_part_M.
% Columns and rows have names 
% (the names are given generically, as `in'/`out' + number 
% (`in' stands for `input', `out' stands for `output').
%
% Warning: rounds entries for display clarity!!!


%
%%%% Details %%%%
% In a single block, only the first row/column's name is displayed, the
% remaining rows/columns have "." displayed instead.
%
% Warning: rounds entries for display clarity!!!
%
% Input: Partititions contain first index of each block plus 
% auxiliary index (size + 1) (index of imaginary (last+1)-th block)
%
% 
% Limitations:
%   row name is displayed not that nicely
%   currently row/column names cannot be chosen by the user (to be implemented)
%

%%%% Do function %%%%

%% columns (here entries are being rounded)
my_table = as_partitioned_only_cols(M, r_part_M);

%% rows
% get numbers of blocks in rows and columns
nrow = size(l_part_M, 2) - 1;
% allocate vector for row names
my_rownames = strings(size(my_table, 1),1);
% create vector of rownames
for i=1:nrow
    for ii=l_part_M(i):(l_part_M(i+1)-1)
        % name only first row of a block
        if ii==l_part_M(i)
            my_rownames(ii) = "blk_row_" + string(i);
        else
            my_rownames(ii) = ".";
        end
    end
end
% add rownames
my_table = addvars(my_table, my_rownames ...
    , 'Before','blk_col_1' ...
    ,'NewVariableNames','BlkRowName');

%% return result
result = my_table;
end