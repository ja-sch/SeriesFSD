function [] = ThueM_equality_validation_eval(A, B, tol_numrank, N, tol_eq)
% Helper function for script ThueM_equality_validation.
%------------------------------------%

% Create Thue-Morse word block lenghts
N_ThueM = 4*N;
ThueM = block_lengths(thuem_seq(N_ThueM));

% (1) Standard (No decomposition)
prod_std = std_eval_ThueM(A,B, N, ThueM);
% (2) Independent SVD
prod_indSVD = indSVD_eval_ThueM(A,B, N, tol_numrank, ThueM);
% (3) Series-FSD
prod_SeriesFSD = SeriesFSD_eval_ThueM(A,B, N, tol_numrank, ThueM);

%%%% Compare values %%%%
% Check equality of (1) and (2)
matrix_ratio = norm(prod_std - prod_indSVD, 'fro')/norm(prod_std, 'fro')
assert(matrix_ratio < tol_eq)

% Check equality of (2) and (3)
matrix_ratio = norm(prod_SeriesFSD - prod_indSVD, 'fro')/norm(prod_indSVD, 'fro')
assert(matrix_ratio < tol_eq)
end