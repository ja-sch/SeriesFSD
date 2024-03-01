% Create input
tol=1e-10
A = [[1;1;1], [1;2;2+tol]]
B = [[2;3;3], [3;5;5]]
% test
colspace_inclusion(A, B, tol) %should be true
colspace_inclusion(A, B, 0) % should be false
