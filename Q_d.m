function [result] = Q_d(size)
%M_d Constant square matrix of size "size".
% Properties: orthogonal.

% result = eye(size);
result = 1/sqrt(size) * hadamard(size);
end