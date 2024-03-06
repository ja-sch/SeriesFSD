function [Block] = get_single_block_of_basis(B, blkj, partition_of_basis)
% Get blkj1-th block of a basis (bases are represented as partitioned matrices that hold vectors in columns).
%
%-----------------------------------%

Block = get_block_minor_only_right_part(B, blkj, blkj, partition_of_basis);

end