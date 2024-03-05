%%%% Runtime comparison %%%%
% In this script we compare evaluation time of term being Thue-Morse word inand under three decompositions:
% (1) Standard (No decomposition)
% (2) Independent SVD
% (3) Series-FSD
% 
% Test outcome: For large enough input Independent SVD allows faster evaluation
% than no decomposition and Series-FSD allows the fastest.
% See the results output by the script.

% Enjoy!

%-----------------------------------%

%%%% Setup %%%%

% Clear environment
clearvars

% Global settings
tol_numrank = 1e-8; % tolerance for computing numerical rank (should be chosen to be smaller than singular values of the to-be obtained blocks, but larger than the `artificially nonzero' singular values that mathematically are actually zero)

%%%% Create input matrices %%%%
% Create input (``raw'')
n = 32; % choose size (must be power of 2 for function my_extended_input6 function to work!)
param = 0.06;N=400;
[wdhatA, wdhatB, Q] = my_extended_input6(n, param);
% Create actual input
[A,B] = raw_input2ready_input(wdhatA, Q, wdhatB);

%%%% Create Thue-Morse word block lenghts %%%%
N_ThueM = 4*N;
ThueM = block_lengths(thuem_seq(N_ThueM));

%%%% Run comparison %%%%
ThueM_runtime_comparison_calc(A,B, N, tol_numrank, ThueM)