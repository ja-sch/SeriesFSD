function [result] = N_d_decr(size)
% N_d_decr: Constant square matrix of size "size".
% Properties: 
%   nonsingular, 
%   singular values are decreasing exponentially.

exponentation_base = 0.95;
result = diag(exponentation_base.^(1:size));
end