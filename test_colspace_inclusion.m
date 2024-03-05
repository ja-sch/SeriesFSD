function [test_result] = test_colspace_inclusion(A,B, tol)
% Tests if colspace of A is contained in colspace of B, using user-defined
% tolerance parameter for numerical errors

test_result = (numrank([A B], tol) == numrank(A, tol));
end