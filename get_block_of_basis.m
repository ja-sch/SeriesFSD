function [Block] = get_block_of_basis(B, blkj1, blkj2, partition_of_basis)
% Get blkj1:blkj2-block-interval of a basis (bases are represented as partitioned matrices that hold vectors in columns).
%
%-----------------------------------%

Block = get_block_minor_only_right_part(B, blkj1, blkj2, partition_of_basis);

end