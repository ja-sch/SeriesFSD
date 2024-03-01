function [product] = std_eval(A, B, N)
% Algorithm ... (from the paper).
% Evaluation in standard bases.
%
% Input: A,B - matrices s.t. A*B is well-defined
%   N - positive integer
% Output: $\prod_{i=1}^N \left((A^* A)(B B^*)^i\right)$ (LaTeX)
%
%-----------------------------------%

H_A = A' * A;
H_B = B * B';
% i=1
factor = H_A * H_B;
product = factor;
for i = 2:N
    factor = factor * H_B;
    product = product * factor;
end

end