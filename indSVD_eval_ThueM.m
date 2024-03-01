function [product] = indSVD_eval_ThueM(A,B, N, tol_numrank, ThueM_block_length)
% Evaluation in Independent SVD bases.
%
% Input and Output like in function std_eval_ThueM.
%-----------------------------------%
%

%%%% preprocess
% get cores and partition (independent SVD)
[G_A_all_as_vec, V_A, Q, U_B, G_B_all_as_vec, k_A, k_B] = preprocess_for_indSVD_eval_ThueM(A, B, tol_numrank);
% get blocks
G_A = diag(G_A_all_as_vec(1:k_A));
G_B = diag(G_B_all_as_vec(1:k_B));
V_A_1 = V_A(:, 1:k_A);
U_B_1 = U_B(:, 1:k_B);
Q_11 = Q(1:k_A, 1:k_B);
%

%%%% eval
% init
wdhatal_11_pow1 = G_A' * G_A;
wdhatal_11_pow2 = wdhatal_11_pow1^2;
wdhatbet_11_pow1 = G_B * G_B';
wdhatbet_11_pow2 = wdhatbet_11_pow1^2;
%
product = 1;
%%% core
% eval
for i = 1:(N-1)
    % read Thue-Morse block lengths
    ni = ThueM_block_length(2*i-1);
    mi = ThueM_block_length(2*i);
    
    % create fact_A
    if ni==1
        fact_A = wdhatal_11_pow1;
    elseif ni==2
        fact_A = wdhatal_11_pow2;
    else
        error("Wrong value of variable ni -- should be either 1 or 2")
    end
    % create fact_B
    if mi==1
        fact_B = wdhatbet_11_pow1;
    elseif mi==2
        fact_B = wdhatbet_11_pow2;
    else
        error("Wrong value of variable mi -- should be either 1 or 2")
    end

    % right-mult the factors to product
    product = product * fact_A * Q_11 * fact_B * Q_11';
end
% i=N
i=N;
% read block lengths
ni = ThueM_block_length(2*i-1);
mi = ThueM_block_length(2*i);

% create fact_A
if ni==1
    fact_A = wdhatal_11_pow1;
elseif ni==2
    fact_A = wdhatal_11_pow2;
else
    error("Wrong value of variable ni -- should be either 1 or 2")
end
% create fact_B
if mi==1
    fact_B = wdhatbet_11_pow1;
elseif mi==2
    fact_B = wdhatbet_11_pow2;
else
    error("Wrong value of variable mi -- should be either 1 or 2")
end

% right-mult the factors to product
product = product * fact_A * Q_11 * fact_B;

%%%% postprocess
product = V_A_1 * product * U_B_1'; % adjust bases

end