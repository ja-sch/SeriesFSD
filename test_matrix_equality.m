function [result] = test_matrix_equality(M1, M2, tol_eq)
% Tests equality up to given absolute tolerance for diff of entries.
%

% Input validation: same sizes of matrices
assert(all(size(M1) == size(M2)) ...
    ,"Input matrices should have same dimensions")
%
tested_value = max(max(abs(M1-M2)))
result = tested_value < tol_eq;
if result == 0
fprintf("Matrix equality test failed.\n Tested matrices:\n")
M1
M2
fprintf("Difference of tested matrices:\n")
M1-M2
fprintf("\n")
end
end