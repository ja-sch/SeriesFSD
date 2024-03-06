function [test_result] = test_colspace_equality(A, B, tol_eq)
% Tests if column space of A is equal to column space of B, using user-defined
% tolerance parameter for numerical errors.

test_result = test_matrix_equality(orth_projector_matrix(A), orth_projector_matrix(B), tol_eq);
end