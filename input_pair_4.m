function [A, B] = input_pair_4(n)
% Input:
% n: positive integer. Must a power of 2.

[A, B, Q] = my_extended_input4(n);

% join Q to a factor (either A or B)
% we arbitrarily choose B
B = Q * B;

% % (Optional) Randomize the bases
% generate random orthogonal bases
L = rand_orth(size(A, 1));
M = rand_orth(size(A, 2)); 
R = rand_orth(size(B, 2));
% modify input
A = L * A * M';
B = M * B * R';
end