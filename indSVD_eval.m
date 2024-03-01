function [product] = indSVD_eval(A,B, N, tol_numrank)
% Algorithm ... (from the paper).
% Evaluation in Independent SVD bases.
%
% Input: A,B - matrices s.t. A*B is well-defined
%   N - positive integer
%   tol_numrank - postive real number. Tolerance parameter used in calculating numrank of a matrix
%       (singular values below tol_numrank -- be it the actual or the ``noise'' ones -- 
%       are ignored)
% Output: $\prod_{i=1}^N \left((A^* A)(B B^*)^i\right)$ (LaTeX)
%
%-----------------------------------%
%

%%%% preprocess
% get SVD
[~, G_A_all_vec, V_A] = svd(A, 'vector');
[U_B, G_B_all_vec, ~] = svd(B, 'vector');
% get numrank
k_A = sum(G_A_all_vec > tol_numrank);
k_B = sum(G_B_all_vec > tol_numrank);
% get blocks
V_A_red = V_A(:, 1:k_A);
U_B_red = U_B(:, 1:k_B);
G_A = diag(G_A_all_vec(1:k_A));
G_B = diag(G_B_all_vec(1:k_B));
Q = V_A' * U_B;
Q_11 = Q(1:k_A, 1:k_B);
%

%
%%%% core
H_A = G_A' * G_A; % init-H_A
H_B = G_B * G_B'; % init-H_B
% i=1
factor = H_A * Q_11 * H_B; % init-factor
product = factor; % init-product
for i=2:(N)
    factor = factor * H_B; % update-factor;
    product = product * Q_11' * factor; % update-product; 
end
%

%%%% postprocess
product = V_A_red * product * U_B_red'; % adjust bases

end