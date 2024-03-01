%%%% Global settings %%%%
tol_numrank = 1e-8; % tolerance for computing numerical rank (should be smaller than singular values of the to-be obtained blocks, but larger than the `artificially nonzero' singular values that mathematically are actually zero)
tol_eq = 1e-9; % tolerance for equality tests

%%%% Perform test %%%%
ThueM_equality_validation_test(tol_numrank, tol_eq)
%%%% Test outcome %%%%
% Test outcome: passed.
