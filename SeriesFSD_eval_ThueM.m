function [product] = SeriesFSD_eval_ThueM(A,B, N, tol_numrank, ThueM_block_length)
% Evaluation in Series-FSD bases.
%
% Input and Output like in function std_eval_ThueM.
%-----------------------------------%
%
% Input validation
assert(N>=2, "Currently not implemented for N=1 (no need to use it in this case anyway).")
%%%% preprocess
% get Series-FSD
[...
        basis_left_A, ... 
        partition_left_A, ...
        core_A, ...
        partition_right_A, ...
        basis_right_A, ...
        core_Q, ...
        basis_left_B, ...
        partition_left_B, ...
        core_B, ...
        basis_right_B, ...
        partition_right_B ...
        ]...
= seriesFSD(A, B, tol_numrank);

% get blocks for init
G_A = get_block_minor(core_A, 1, 2, 1, 2, partition_left_A, partition_right_A);
G_B = get_block_minor(core_B, 1, 2, 1, 2, partition_left_B, partition_right_B);

% init
wdhatal_11_depth1_pow1 = G_A' * G_A;
wdhatal_11_depth1_pow2 = wdhatal_11_depth1_pow1^2;
wdhatbet_11_depth1_pow1 = G_B * G_B';
wdhatbet_11_depth1_pow2 = wdhatbet_11_depth1_pow1^2;
% get blocks for eval
% core
% A
wdhatal_11_depth2_pow1 = get_block(wdhatal_11_depth1_pow1, 1, 1, partition_right_A, partition_right_A); % left of A' = right of A
wdhatal_11_depth2_pow2 = get_block(wdhatal_11_depth1_pow2, 1, 1, partition_right_A, partition_right_A); % left of A' = right of A
% Q
Q_11_depth2 = get_block(core_Q, 1, 1, partition_right_A, partition_left_B);
% B
wdhatbet_11_depth2_pow1 = get_block(wdhatbet_11_depth1_pow1, 1, 1, partition_left_B, partition_left_B); % right of B' = left of B 
wdhatbet_11_depth2_pow2 = get_block(wdhatbet_11_depth1_pow2, 1, 1, partition_left_B, partition_left_B); % right of B' = left of B 

% left adjustment for basis
blki1=1;blki2=2;left_adj_basis = get_block_of_basis(basis_right_A, blki1, blki2, partition_right_A);

% right adjustment for basis
blki1=1;blki2=2;right_adj_basis = get_block_of_basis(basis_left_B, blki1, blki2, partition_left_B)'; % notice the conjT

%%%% eval
%
product = 1;
%%% core
% eval
% begin with i=2 for optimization reasons 9first factor has larger
% dimensions)
for i = 2:(N-1)
    % read block lengths
    ni = ThueM_block_length(2*i-1);
    mi = ThueM_block_length(2*i);
    
    % create fact_A
    if ni==1
        fact_A = wdhatal_11_depth2_pow1;
    elseif ni==2
        fact_A = wdhatal_11_depth2_pow2;
    else
        error("Wrong value of variable ni -- should be either 1 or 2")
    end
    % create fact_B
    if mi==1
        fact_B = wdhatbet_11_depth2_pow1;
    elseif mi==2
        fact_B = wdhatbet_11_depth2_pow2;
    else
        error("Wrong value of variable mi -- should be either 1 or 2")
    end

    % right-mult the factors to product
    product = product * fact_A * Q_11_depth2 * fact_B * Q_11_depth2';
end
%
% i=1
i=1;
    % read block lengths
ni = ThueM_block_length(2*i-1);
mi = ThueM_block_length(2*i);
    % create fact_A - tall matrix
blki1=1;blki2=2;
blkj1=1;blkj2=1;
if ni==1
    fact_A = get_block_minor(wdhatal_11_depth1_pow1, ...
        blki1, blki2, blkj1, blkj2, partition_right_A, partition_right_A); % left of A' = right of A
elseif ni==2
    fact_A = get_block_minor(wdhatal_11_depth1_pow2, ...
        blki1, blki2, blkj1, blkj2, partition_right_A, partition_right_A); % left of A' = right of A
else
    error("Wrong value of variable ni -- should be either 1 or 2")
end
    % create fact_B - same as in the loop
if mi==1
    fact_B = wdhatbet_11_depth2_pow1;
elseif mi==2
    fact_B = wdhatbet_11_depth2_pow2;
else
    error("Wrong value of variable mi -- should be either 1 or 2")
end
    % left-mult the factors to product - left-mult instead of right-mult which is as in the loop
product = fact_A * Q_11_depth2 * fact_B * Q_11_depth2' * product;
%
% i=N
i=N;
    % read Thue-Morse block lengths
ni = ThueM_block_length(2*i-1);
mi = ThueM_block_length(2*i);

    % create fact_A - same as in the loop
if ni==1
    fact_A = wdhatal_11_depth2_pow1;
elseif ni==2
    fact_A = wdhatal_11_depth2_pow2;
else
    error("Wrong value of variable ni -- should be either 1 or 2")
end
    % create fact_B - wide matrix
blki1=1;blki2=1;
blkj1=1;blkj2=2;
if mi==1
    fact_B = get_block_minor(wdhatbet_11_depth1_pow1, blki1, blki2, blkj1, blkj2, partition_left_B, partition_left_B); % right of B' = left of B
elseif mi==2
    fact_B = get_block_minor(wdhatbet_11_depth1_pow2, blki1, blki2, blkj1, blkj2, partition_left_B, partition_left_B); % right of B' = left of B
else
    error("Wrong value of variable mi -- should be either 1 or 2")
end

% right-mult the factors to product - no right-mult of Q_11_depth2'
product = product * fact_A * Q_11_depth2 * fact_B;

%%%% postprocess
product = left_adj_basis * product * right_adj_basis; % adjust bases

end