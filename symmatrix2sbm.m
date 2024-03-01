function [Asbm] = symmatrix2sbm(A)
% Converts symmatrix to SymbolicBlockMatrix (sbm).
    
    % Allocate a cell
    Asbm = cell(size(A,1),size(A,2));
    % Copy values to a cell
    for i=1:size(Asbm, 1)
        for j=1:size(Asbm, 2)
            Asbm{i, j} = A(i,j);
        end
    end
    % Create sbm
    Asbm = SymbolicBlockMatrix(Asbm);
end
