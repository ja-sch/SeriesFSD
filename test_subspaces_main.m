%%%% TEST SUBSPACES
%%%% We verify the paper's way of computing the subspaces.
%%%% We verify the paper's formula for the spaces spanned by blocks of bases matrices.
%%%% We do it for matrix A, both left and right basis.
%%%% We verify all except the last basis, as the result follows by
%%%% orthogonal complement.
%%%% We verify only A, because B is dual (if the way of computing
%%%% the subspaces worked for A, then most probably it is a correct one.
%%%% Also, then definitely the analogous formulas work for B).
%---------------------------------------------------------%


fprintf("\nRunning tests of subspaces.\n")

%%%% SETUP %%%%
% clear environment
clearvars

% Global settings %
tol_numrank = 1e-8; % tolerance for computing numerical rank (should be smaller than singular values of the to-be obtained blocks, but larger than the `artificially nonzero' singular values that mathematically are actually zero)
tol_eq = 1e-12 % tolerance for equality test

%%%% Create input %%%%
fprintf("Creating input:\n")
% Create 'raw' input 
n = 1; % choose size (must be power of 2 for function my_extended_input6 function to work!)
param = 0.06;
[wdhatA, wdhatB, Q] = my_extended_input6(n, param);
% Create actual input
[A,B] = raw_input2ready_input(wdhatA, Q, wdhatB);


%%%% TESTS %%%%
test_subspaces_test(A, B, tol_numrank, tol_eq)
