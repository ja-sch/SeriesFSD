function [G_A_all_as_vec, V_A, Q, U_B, G_B_all_as_vec, k_A, k_B] = preprocess_for_indSVD_eval_ThueM(A, B, tol_numrank)
% Preprocess phase of function indSVD_eval_ThueM

% get SVD
[~, G_A_all_as_vec, V_A] = svd(A, 'vector');
[U_B, G_B_all_as_vec, ~] = svd(B, 'vector');
% get adapter
Q = V_A' * U_B;

% get numrank (for partition)
k_A = sum(G_A_all_as_vec > tol_numrank);
k_B = sum(G_B_all_as_vec > tol_numrank);
end