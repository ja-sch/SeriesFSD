function [A, B, Q] = my_extended_input2(n)
% Creates some matrices A, Q, B such that
% rank(A)  = 3 * n
% rank(AQB) = n
% rank(B)  = 2 * n
% Q is orthogonal
% 
%% cores
% A
valA = 0.45; % just some number, different than for B
blk1A = [N_d(n), zeros(n,n), zeros(n,n); ...
         3*valA*M_d(n), N_d(n), zeros(n,n); ...
         2*valA*M_d(n), valA*M_d(n), N_d(n)];
blk2A = zeros(2*n, 2*n);
A = blkdiag(blk1A, blk2A);

% Q
Q = blkdiag(Q_d(n), Q_d(2*n), Q_d(n), Q_d(n));

% B
valB = 0.3; % just some number, different than for A
blk1B = [N_d(n), zeros(n, 2* n), valB *M_d(n);
        zeros(n, 4*n);
        zeros(n, 4*n);...
        zeros(n, 3*n), N_d(n)];
blk2B = zeros(n,n);
B = blkdiag(blk1B, blk2B);


end