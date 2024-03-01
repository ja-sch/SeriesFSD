function [product] = std_eval_ThueM(A, B, N, ThueM_block_length)
% Evaluation in standard bases.
%
% Input: A,B - matrices s.t. A*B is well-defined
%   N - positive integer
%   ThueM_block_length = sequence of interleaving $n_i$'s and $m_i$'s (see
%   their definition in 'Output')
% Output: 
%   $\prod_{i=1}^N \left((A^* A)^{n_i} (B B^*)^{m_i}\right)$ (LaTeX)
%   where $(n_i)^\infty_{i=1}$ and $(m_i)^\infty_{i=1}$ are (respectively)
%   sequences of length of blocks of consecutive 0's and (respectively) 1's in 
%   the Thue-Morse word; for example
%$ 
%     n_1 = 1, 
%     m_1 = 2, 
%     n_2 = 1, 
%     m_2 = 1,
%     n_3 = 2, 
%     m_3 = 2
% $
%
%-----------------------------------%

% init
al_pow1 = A' * A;
al_pow2 = al_pow1^2;
bet_pow1 = B * B';
bet_pow2 = bet_pow1^2;
product = 1;

% eval
for i = 1:N
    % read Thue-Morse block lengths
    ni = ThueM_block_length(2*i-1);
    mi = ThueM_block_length(2*i);
    
    % create fact_A
    if ni==1
        fact_A = al_pow1;
    elseif ni==2
        fact_A = al_pow2;
    else
        error("Wrong value of variable ni -- should be either 1 or 2")
    end
    % create fact_B
    if mi==1
        fact_B = bet_pow1;
    elseif mi==2
        fact_B = bet_pow2;
    else
        error("Wrong value of variable mi -- should be either 1 or 2")
    end

    % right-mult the factors to product
    product = product * fact_A * fact_B;
end

end