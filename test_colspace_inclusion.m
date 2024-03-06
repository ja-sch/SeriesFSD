function [test_result] = test_colspace_inclusion(A,B, tol_eq)
% Tests if colspace of A is contained in colspace of B, using user-defined
% tolerance parameter for numerical errors
%
% We use normalized measure of inclusion -- P_B * A == A would require
% adjusting tol_eq for A.

P_A = orth_projector_matrix(A);
P_B = orth_projector_matrix(B);
%
LHS = P_A;
RHS = P_B * P_A;

test_result = test_matrix_equality(LHS, RHS, tol_eq);
end