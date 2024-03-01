function [product] = pre_indSVD_eval(A,B, N)
% Prototype version of function indSVD_eval
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

%%%% preprocess
% get SVD
[~, wdhatA, V_A] = svd(A)
[U_B, wdhatB, ~] = svd(B)
% % get numrank
% k_A = sum(wdhatA_all > tol_numrank)
% k_B = sum(wdhatB_all > tol_numrank)
% get blocks
Q = V_A' * U_B
% Q_11 = Q(1:k_A, 1:k_B)

%%%% core
H_A = wdhatA' * wdhatA % init-H_A
H_B = wdhatB * wdhatB' % init-H_B
% i=1
factor = H_A * Q * H_B % init-factor
product = factor % init-product
for i=2:N
    factor = factor * H_B % update-factor;
    product = product * Q' * factor % update-product; 
end

%%%% postprocess
product = V_A * product * U_B' % adjust bases


end