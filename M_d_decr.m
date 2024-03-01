function [result] = M_d_decr(size, param)
% M_d Constant square matrix of size "size".
% Input:
%    size: positive integer -- size of output matrix
%    param: some value between 0 and 1 -- (approximately) equal to ratio of
%    (Frob norm of output matrix)/size
% Output:
%   result: matrix
%
% Properties of result: 
%  (Frobenius norm)/size is between 0 and 1.

A = zeros(size);

for i=1:size
    for j=1:size
        A(i,j) = 1/(size*(i-1) + j);
    end
end
A = param * (size * sqrt(6)/pi) * A;
result = A;
end