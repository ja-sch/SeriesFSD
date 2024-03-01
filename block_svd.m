function [U_A, Big_sigma_A, V_A] = block_svd(A, tol_numrank)
%block_svd Block version of svd.
% Inputs a matrix (a block), outputs three BlockMatrix objects,
% partitioned into blocks according to corresponding singular values
% being above given threshold (``numerically'' positive) or less or equal.
% 
% Input:
%   A: matrix - input matrix to be SVD-eed
%   tol_numrank: double - tolerance parameters used for calculating
%   numerical rank
%
% Output:
%   U_A: BlockMatrix - base of singular vectors, partitioned vertically into two blocks
%   between *numerical* colspace (i.e., corr to singvals >
%   tol_numrank) and *numerical* nullspace (i.e., corr to singvals <=
%   tol_numrank)
%   Big_sigma_A: BlockMatrix - as in svd, partitioned to be (2 x 2)
%   BlockMatrix similarly as U_A, based on (singvals >
%   tol_numrank)
%   V_A: BlockMatrix - as in svd, with the partition into blocks analogously as for U_A

% do 'plain' matrix svd
[U_A, sigma_A, V_A] = svd(A, "vector");

% get numrank
sigmaPos_A = sigma_A(sigma_A > tol_numrank); % ``numerically'' positive singvals
sigmaNegl_A = sigma_A(sigma_A <= tol_numrank); % negligible singvals
assert(all([sigmaPos_A; sigmaNegl_A] == sigma_A)); %verify that partition of sigma vector is good
numrank_A = size(sigmaPos_A, 1); % number of nonnegligible singvals

% partition into blocks
U_A = {U_A(:, 1:numrank_A), U_A(:, (numrank_A+1):size(U_A,2))};
U_A = BlockMatrix(U_A);
V_A = {V_A(:, 1:numrank_A), V_A(:, (numrank_A+1):size(V_A,2))};
V_A = BlockMatrix(V_A);
% reformat sigma matrices
Big_sigmaPos_A = {diag(sigmaPos_A)};
Big_sigmaPos_A = BlockMatrix(Big_sigmaPos_A);
Big_sigmaNegl_A = {diag(sigmaNegl_A)};
Big_sigmaNegl_A = BlockMatrix(Big_sigmaNegl_A);

% create Big Sigma matrix
% blocks are matrices (that is, same MATLAB type as a matrix)
blkBig_sigma_A11 = Big_sigmaPos_A.C{1,1};
blkBig_sigma_A12 = zeros(numrank_A, size(A,2) - numrank_A);
blkBig_sigma_A21 = zeros(size(A,1) - numrank_A, numrank_A);
blkBig_sigma_A22 = Big_sigmaNegl_A.C{1,1};
Big_sigma_A = {blkBig_sigma_A11, blkBig_sigma_A12; ...
               blkBig_sigma_A21, blkBig_sigma_A22};
Big_sigma_A = BlockMatrix(Big_sigma_A);

end