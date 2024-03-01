function [test_result] = colspace_equality(A, B, tol)
% Tests if colspace of A is contained in colspace of B, using user-defined
% tolerance parameter for numerical errors

test_result = (colspace_inclusion(A, B, tol) & colspace_inclusion(B, A, tol));
end