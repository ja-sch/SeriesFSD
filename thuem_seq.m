function [thuem] = thuem_seq(N)
% Input: N: positive integer
% Output: thuemorse sequence prefix of length at least N
%------------------------------------------%

% i=0
thuem = [0]; % init thue morse sequence
ix= 1; % last updated index
for i=1:ceil(log2(N))
    new_ix = 2*ix;
    thuem(ix +1: new_ix) = 1-thuem(1:ix);
    ix=new_ix;
end
end