% In this sheet we compare runtime of Algorithm ...
% under three decompositions:
% (1) Standard (No decomposition)
% (2) Independent SVD
% (3) Series-FSD % to be implemented
% 
% Enjoy!
%-----------------------------------------%

%%%% Setup, create input
clearvars % Clear environment
% Global settings
tol_numrank = 1e-8; % tolerance for computing numerical rank (should be smaller than singular values of the to-be obtained blocks, but larger than the `artificially nonzero' singular values that mathematically are actually zero)
tol_eq = 1e-9; % tolerance for equality tests (on 1e-15 some test failed)

% Create input matrices
% other variant
    % % Create input (``raw'')
    % n = 2; % choose size (must be power of 2 for function my_extended_input4 function to work!)
    % [wdhatA, wdhatB, Q] = my_extended_input4(n);
    % % Create actual input
    % [A,B] = raw_input2ready_input(wdhatA, Q, wdhatB) % works on that for $n\in\{1,2\}$
    % N=500;
% end of: other variant
%
% used variant
A=[0.999998 0.0003];B=[1.000003;0.0009]; N=2000;% works well, total time SVD is 5% of total time std

%%%% Validation: Check outputs and their diffs
% (1) Standard (No decomposition)
prod_std = std_eval(A,B, N)
% (2) Independent SVD
prod_indSVD = indSVD_eval(A,B, N, tol_numrank)
% Check equality
% diff = prod_std - prod_indSVD
matrix_ratio = norm(prod_std - prod_indSVD, 'fro')/norm(prod_std, 'fro')
assert(matrix_ratio < tol_eq)

% Compare times
handle_std_eval = @() std_eval(A,B, N); % handle to function
t_std = timeit(handle_std_eval)
handle_indSVD = @() indSVD_eval(A,B, N, tol_numrank); % handle to function
t_indSVD = timeit(handle_indSVD)
%
time_ratio_SVD_vs_std = t_indSVD/t_std
