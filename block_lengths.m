function [bl] = block_lengths(s)
% Input: s: sequence of 0's and 1's
% Output: bl: sequence of block lengths
%-----------------------------------%

N=length(s); % read sequence length
%
bl=[]; %init array for block lengths
% i=1
i = 1;
iblock = 1;
new_char = s(i);
l=1; % block length
if i==N % that is, if N==1
    % dump previous block
    bl(iblock) = l;
end
for i=2:N
    % dump outdated new_char
    char=new_char; 
    % read next char
    new_char = s(i);
    if new_char == char
        % update block index -- no action needed
        % update block length
        l=l+1; % increase block length
    else
        % dump previous block
        bl(iblock) = l;
        % update block index
        iblock = iblock+1; % get next block index
        % update block length
        l=1;
    end
end
end