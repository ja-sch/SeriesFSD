function [test_result] = test_colspace_equality(A, B, tol)
% Tests if column space of A is equal to column space of B, using user-defined
% tolerance parameter for numerical errors.

test_result = (test_colspace_inclusion(A, B, tol) & test_colspace_inclusion(B, A, tol));
end