% This sheet can compute Series Fundamental Subspaces Decomposition.
% See the description of the algorithm below (section ``About algorithm and this implementation'').
% Feel free to run it your the pair of matrices of your choice, and 
% see the decomposition in a visually more attractive way 
% by running script display_decomposition.mlx.
% Adjust global settings (tol_numrank, tol_eq) if needed.
% Enjoy!
% 
% Input requirements: matrix A has as many columns as matrix B has rows.
% Limitations: the decomposition is computed correctly but 
% there is a limitation in displaying trivial block-rows,
% see documentation of function seriesFSD.


%----------------------------------------------%

fprintf("\nRunning Series-FSD.\n")
% % Choose input & global settings
% global settings
tol_numrank = 1e-8; % tolerance for computing numerical rank (should be chosen to be smaller than singular values of the to-be obtained blocks, but larger than the `artificially nonzero' singular values that mathematically are actually zero)
tol_eq = 1e-12; % tolerance for equality tests
% input
n = 4; % choose size of matrices (n must be a power of 2 for function my_extended_input4 function to work!)
fprintf("Creating input matrices A,B: \n")
[A, B] = input_pair_4(n)

% % Run implementation

% Compute Series-FSD
fprintf("Computing Series-FSD:\n")
[left_A, l_part_A, core_A, r_part_A, right_A,  ...
core_Q, left_B, l_part_B, core_B, right_B, r_part_B]...
=...
seriesFSD(A, B, tol_numrank)

%%% Display the decomposition (Series-FSD) %%%
% To display the decomposition, visit the following file:
%           display_decomposition.mlx

fprintf("Series-FSD of input matrices has been computed. \n To display the decomposition in a more visually attractive way, visit the following file: display_decomposition.mlx.\n")
