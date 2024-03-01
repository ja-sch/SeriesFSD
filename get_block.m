function [Block] = get_block(M, blki, blkj, partition_left_M, partition_right_M)
% Get (i,j)-block of partitioned matrix M.
%
%-----------------------------------%

[i1,i2] = blk_endpts2endpts(blki, blki+1, partition_left_M);
[j1,j2] = blk_endpts2endpts(blkj, blkj+1, partition_right_M);
Block = M(i1:i2, j1:j2);

end