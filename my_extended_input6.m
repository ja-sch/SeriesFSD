function [A, B, Q] = my_extended_input6(n, param)
% Identical to function my_extended_input5 but:
%   with function N_d replaced by function N_d_decr
%   with function M_d replaced by function M_d_decr
% 
%% cores
% A
valA = 0.33; % just some number, different than for B
blk1A = [N_d_decr(n), 3*valA*M_d_decr(n, param) , 2*valA*M_d_decr(n, param); ...
         zeros(n,n), N_d_decr(n)    , valA*M_d_decr(n, param); ...
         zeros(n,n), zeros(n,n), N_d_decr(n)];
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
blk1B = [N_d_decr(n)      , zeros(n, n);
        valB * M_d_decr(n, param), N_d_decr(n)];
blk2B = [zeros(2*n,n);
         zeros(n,n)];
B = blkdiag(blk1B, blk2B);


end