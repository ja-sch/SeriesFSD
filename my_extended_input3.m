function [A, B, Q] = my_extended_input3(n)
% Creates some matrices A, Q, B such that
% rank(A)  = 3 * n
% rank(AQB) = n
% rank(B)  = 2 * n
% Q is orthogonal
% Our decomposition is in almost full generality for this input (no block is trivial, i.e.
% 0-dimensional, but Q_14 and Q_41 are 0)
% 
%% cores
% A
valA = 0.45; % just some number, different than for B
blk1A = [N_d(n), 3*valA*M_d(n) , 2*valA*M_d(n); ...
         zeros(n,n), N_d(n)    , valA*M_d(n); ...
         zeros(n,n), zeros(n,n), N_d(n)];
blk2A = zeros(n, 2*n);
A = blkdiag(blk1A, blk2A);

% Q
Q = [Q_d(n)     ,zeros(n, n)  ,zeros(n,2*n),zeros(n,n); ...
    zeros(2*n,n),zeros(2*n,n) ,Q_d(2*n)    ,zeros(2*n,n);...
    zeros(n,n)  ,Q_d(n)       ,zeros(n,2*n),zeros(n,n);...
    zeros(n,n)  ,zeros(n,n)   ,zeros(n,2*n),Q_d(n)];

% B
valB = 0.3; % just some number, different than for A
blk1B = [N_d(n)      , zeros(n, n);
        valB * M_d(n), N_d(n)];
blk2B = [zeros(2*n,n);
         zeros(n,n)];
B = blkdiag(blk1B, blk2B);


end