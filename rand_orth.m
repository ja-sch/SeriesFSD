function [result] = rand_orth(n)
%UNTITLED5 Random (square) orthogonal matrix of size n (not sure with what
%distribution)


[result, ~] = qr(rand(n));
end