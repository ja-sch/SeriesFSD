function [A, B, Q] = my_extended_input5(n)
% Identical to function my_extended_input4 but with valA=0.33
% 
%% cores
% A
valA = 0.33; % just some number, different than for B
blk1A = [N_d(n), 3*valA*M_d(n) , 2*valA*M_d(n); ...
         zeros(n,n), N_d(n)    , valA*M_d(n); ...
         zeros(n,n), zeros(n,n), N_d(n)];
blk2A = zeros(n, 2*n);
A = blkdiag(blk1A, blk2A);

% Q
h = 1/sqrt(2); % for hadamard matrix
Q = [h * eye(n)     ,zeros(n, n)  ,zeros(n,2*n),h * eye(n); ...
    zeros(2*n,n),zeros(2*n,n) ,Q_d(2*n)    ,zeros(2*n,n);...
    zeros(n,n)  ,Q_d(n)       ,zeros(n,2*n),zeros(n,n);...
    h * eye(n)  ,zeros(n,n)   ,zeros(n,2*n),-h * eye(n)];

% B
valB = 0.3; % just some number, different than for A
blk1B = [N_d(n)      , zeros(n, n);
        valB * M_d(n), N_d(n)];
blk2B = [zeros(2*n,n);
         zeros(n,n)];
B = blkdiag(blk1B, blk2B);


end