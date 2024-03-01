function [numrank_A] = numrank(A, tol)
% Computes numerical rank of a matrix based on the tolerance (threshold) for singular
% values

[~, sigma_A_vec, ~] = svd(A, "vector");
% numrank
numrank_A = sum(sigma_A_vec > tol); % number of ``numerically'' nonnegligible singvals
end