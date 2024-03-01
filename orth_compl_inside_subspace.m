function [result] = orth_compl_inside_subspace(V, W)
%UNTITLED Orthogonal complement of a space colspace(V) inside (or equivalently, intersected with) a larger space,
% both being subspaces of the same Euclidean space.
% Precisely, it computes (Orthogonal complement of colspace(V)) intersected
% with colspace(W).
% We assume (and check if) V, W are orthogonal matrices.

% To get the result, we apply the formula, further described in the paper.
%
% Input:
%   V: matrix
%   m: integer
%   W: matrix
%   n: integer
%
% Input description:
%   V: orth basis of the smaller subspace
%   m: declared dim of V
%   W: orth basis of the larger subspace
%   n: declared dim of W
% Input validation 
%   errors (if below properties do not hold):
%     m <= n
%     V, W have same number of rows
%   warnings (if below properties do not hold):
%     V: has orthogonal columns
%     W: has orthogonal columns
%     colspace(V) \subset colspace(W)
%
% Output:
%   result: matrix
%     properties: 
%       has orthogonal columns,
%       colspace(result) = colspace(V)^\bot \cap colspace(W).
%
    
    % Input validation (errors):
    assert(size(V, 1) == size(W, 1) ...
        , "Input matrices should have same number of rows")
    dim = size(V, 1);
    % Input validation (warnings):
    tol = 1e-15; % arbitrarily chosen tolerance level
    %   V: has orthogonal columns
    if ~has_orth_cols(V, tol)
        warning("Columns of first input matrix should be orthonormal but seem not to be")
    end
    %   W: has orthogonal columns
    if ~has_orth_cols(W, tol)
        warning("Columns of second input matrix should be orthonormal but seem not to be")
    end
    %   colspace(V) \subset colspace(W)
    if ~test_matrix_equality(W * W' * V, V, tol)
        warning("Column space of first input matrix should be contained in " + ...
            "column space of second input matrix but seems not to be," + ...
            " assuming second input matrix has orthogonal columns")
    end

    % do function
    
    %%%% solution 1 (currently used)
    result = W * null(V' * W);
    %%%% end of: solution 1
    
    %%%% solution 2 (not used, but might be considered if the first one is 
    % too much off numerically) - define result as (projections of) solutions to system of equations
%     
%     mV = size(V, 2);
%     mW = size(W, 2);
%     % define matrix for system of equations
%     M = [V', zeros(mV, mW); % orth to V
%          -eye(size(W, 1)), W % in colspace of W
%          ];
%     sols = null(M);
%     result = sols(1:dim, 1); % project 'out' the found preimages of v from W
    %%%% end of: solution 2
end