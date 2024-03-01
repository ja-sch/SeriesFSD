function [result] = has_orth_cols(M, tol)
% Checks if columns are orthogonal, up to given tolerance
%
result = test_matrix_equality(M' * M, eye(size(M, 2)), tol);
end