function [A, B] = raw_input2ready_input(wdhatA, Q, wdhatB)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%%% Input validation
n = size(wdhatA, 2);
assert(size(Q, 1) == n)
assert(size(Q, 2) == n)
assert(size(wdhatB, 1) == n)

%%%% do function
% join Q to a factor (either A or B)
% we arbitrarily choose B
B = Q * wdhatB;
A = wdhatA;

%%(Optional) Randomize the bases
% generate random orthogonal bases
% L = rand_orth(size(A, 1));
% M = rand_orth(size(A, 2)); 
% R = rand_orth(size(B, 2));
% % modify input
% A = L * A * M';
% B = M * B * R';

end