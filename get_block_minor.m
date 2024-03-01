function [Block] = get_block_minor(M, blki1, blki2, blkj1, blkj2, partition_left_M, partition_right_M)
% Get (blki1:blki2, blkj1:blkj2)-block-minor of partitioned matrix M.
%
%-----------------------------------%

[i1,i2] = blk_endpts2endpts(blki1, blki2+1, partition_left_M);
[j1,j2] = blk_endpts2endpts(blkj1, blkj2+1, partition_right_M);
Block = M(i1:i2, j1:j2);

end