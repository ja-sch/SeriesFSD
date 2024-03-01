function [] = ThueM_equality_validation_test(tol_numrank, tol_eq)
% In this function we validate that these three functions:
%     std_eval_ThueM
%     indSVD_eval_ThueM
%     SeriesFSD_eval_ThueM
% are equivalent (return the same output).
%--------------------------------------%

fprintf("Running equality validation for three ways to evaluate the ``Thue-Morse'' product.\n")
fprintf("Tolerance for equality tests: %d.\n\n", tol_eq)


%%%% Create input %%%%
fprintf("Creating input:\n")
% Create 'raw' input 
n = 32; % choose size (must be power of 2 for function my_extended_input6 function to work!)
param = 0.06;N=400;
[wdhatA, wdhatB, Q] = my_extended_input6(n, param);
% Create actual input
[A,B] = raw_input2ready_input(wdhatA, Q, wdhatB);
% display input size
max_dim_A = max(size(A));
max_dim_B = max(size(B));
max_matrix_dim = max(max_dim_A, max_dim_B);
fprintf("Matrix size: %d.\n", max_matrix_dim)
fprintf("Number of iterations: %d.\n", N)

%%%% Evaluate %%%%
fprintf("Validating:")
ThueM_equality_validation_eval(A, B, tol_numrank, N, tol_eq)

fprintf("Test outcome: test passed.\n")

%%%% Test outcome %%%%
% Test outcome: passed.
end