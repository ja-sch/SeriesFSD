function [A, B, Q] = my_extended_input1(n)
%
% A
valA = 1.15; % just some number, different than for B
blk1A = [N_d(n), zeros(n,n); ...
        valA*M_d(n), N_d(n)];
blk2A = [zeros(2*n, 2*n)];
A = blkdiag(blk1A, blk2A);

Q = blkdiag(Q_d(n), Q_d(n), Q_d(n), Q_d(n));

% B
valB = 1.1; % just some number, different than for A
blk1B = [N_d(n), zeros(n,n), valB *M_d(n);
        zeros(n, 3*n);
        zeros(n, 2*n), N_d(n)];
blk2B = zeros(n,n);
B = blkdiag(blk1B, blk2B);
end