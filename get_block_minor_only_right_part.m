function [Block] = get_block_minor_only_right_part(M, blkj1, blkj2, partition_right_M)
% Get (:, blkj1:blkj2)-block-minor of partitioned matrix M.
%
%-----------------------------------%

[j1,j2] = blk_endpts2endpts(blkj1, blkj2+1, partition_right_M);
Block = M(:, j1:j2);

end