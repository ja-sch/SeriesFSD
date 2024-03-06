function [] = test_subspaces_test(A, B, tol_numrank, tol_eq)
% In this function we validate that the formulas for the subspaces from the
% paper are correct.
% Tested cases:
%%% A: first block, left basis %%%
%%% A: first block, right basis %%%
%%% A: first two blocks, left basis %%%
%%% A: first two blocks, right basis %%%
%%% A: third block, right basis %%%

% Remaining test cases for A follow by orthogonal complement.
% Tests for B are not run because the formulas are dual.
%--------------------------------------%

%%%% create Series-FSD %%%%
[...
        basis_left_A, ... 
        partition_left_A, ...
        core_A, ...
        partition_right_A, ...
        basis_right_A, ...
        core_Q, ...
        basis_left_B, ...
        partition_left_B, ...
        core_B, ...
        basis_right_B, ...
        partition_right_B ...
        ]...
= seriesFSD(A, B, tol_numrank);

%%%% Print input stats %%%%
% Dimensions
max_dim_A = max(size(A));
max_dim_B = max(size(B));
max_matrix_dim = max(max_dim_A, max_dim_B);
fprintf("Matrix size: %d.\n", max_matrix_dim)

% Ranks
fprintf("Rank A: %d.\n", partition_left_A(3) - partition_left_A(1))
% fprintf("Rank A: %d.\n", rank(A)) % can be commented out for speed-up
fprintf("Rank B: %d.\n", partition_left_B(3) - partition_left_B(1))
% fprintf("Rank B: %d.\n", rank(B)) % can be commented out for speed-up
fprintf("Rank A: %d.\n", partition_left_A(2) - partition_left_A(1))
% fprintf("Rank AB: %d.\n", rank(A*B)) % can be commented out for speed-up

%%%% TESTS %%%%

% A

%%% A: first block, left basis %%%
% define test input
tested_subspace_matrix = A*B;
basis_matrix = basis_left_A;
basis_partition = partition_left_A;
blkj = 1; % index of tested block (of basis matrix)

% get block of basis
basis_block = get_single_block_of_basis(basis_matrix, blkj, basis_partition);

% do test
test_colspace_equality(basis_block, tested_subspace_matrix, tol_eq)

%%% A: first block, right basis %%%
blkj = 1; % index of tested block
tested_subspace_matrix = pinv(A) * A * B;
% get block indices
j1 = partition_right_A(blkj);
j2 = partition_right_A(blkj+1) - 1;
% do test
test_colspace_equality(basis_right_A(:, j1:j2), tested_subspace_matrix, tol_eq)

%%% A: first two blocks, left basis %%%
blkj = 1; % index of tested block
tested_subspace_matrix = A;
% get block indices
j1 = partition_left_A(blkj);
j2 = partition_left_A(blkj+2) - 1;
% do test
test_colspace_equality(basis_left_A(:, j1:j2), tested_subspace_matrix, tol_eq)

%%% A: first two blocks, right basis %%%
blkj = 1; % index of tested block
tested_subspace_matrix = A';
% get block indices
j1 = partition_right_A(blkj);
j2 = partition_right_A(blkj+2) - 1;
% do test
test_colspace_equality(basis_right_A(:, j1:j2), tested_subspace_matrix, tol_eq)

%%% A: third block, right basis %%%
% define test case
tested_subspace_matrix = orth_projector_matrix(B) - orth_projector_matrix(orth_projector_matrix(B) * A');
basis_matrix = basis_right_A;
basis_partition = partition_right_A;
blkj = 3; % index of tested block (of basis matrix)
% get block of basis
basis_block = get_single_block_of_basis(basis_matrix, blkj, basis_partition);
% do test
test_colspace_equality(basis_block, tested_subspace_matrix, tol_eq)


end