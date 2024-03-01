function [C] = test_modify_cell_inplace(C)
    for i=1:size(C,1)
        C{i} = C{i} * 2;
    end
end