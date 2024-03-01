function [i_1,i_2] = blk_endpts2endpts(blki_1, blki_2, part)
% Gets endpoints of the interval out of given block-endpoints.
% Input:
%   blki_1, blki_2: positive integers, smaller than max(part)
%   part: non-decreasing sequence of positive integers (represents a partition)
% Output:
%   i_1,i_2: endpoints of the actual interval equivalent to a
%   block-interval with endpoints blki_1, blki_2
% 
% Example: in a partition 12|34|5|6789|10,
% block-indices 2,4 give block-interval consisting of block 2,3,4, that is,
% 34|5|6789, and actual indices are 3:9. In other words:
%   blk_ix2ix(2,4,(1,3,5,6,10,11)) = (3,9).
i_1 = part(blki_1);
i_2 = part(blki_2) - 1;
end