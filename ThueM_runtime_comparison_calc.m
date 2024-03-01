function [] = ThueM_runtime_comparison_calc(A,B, N, tol_numrank, ThueM)

% This function runs comparison of runtimes of three ways to evaluate the ``Thue-Morse
% product''.
fprintf("Running runtime comparison for three ways to evaluate the ``Thue-Morse'' product.\n")
max_dim_A = max(size(A));
max_dim_B = max(size(B));
max_matrix_dim = max(max_dim_A, max_dim_B);
fprintf("Matrix size: %d.\n", max_matrix_dim)
fprintf("Number of iterations: %d.\n", N)
%%%% Measure times %%%%
% total time
handle_std_eval = @() std_eval_ThueM(A,B, N, ThueM); % handle to function
t_std = timeit(handle_std_eval);

handle_indSVD = @() indSVD_eval_ThueM(A,B, N, tol_numrank, ThueM); % handle to function
t_total_indSVD = timeit(handle_indSVD);
time_ratio_SVD_vs_std = t_total_indSVD/t_std; % time ratio

handle_SeriesFSD = @() SeriesFSD_eval_ThueM(A,B, N, tol_numrank, ThueM); % handle to function
t_total_SeriesFSD = timeit(handle_SeriesFSD);
time_ratio_SeriesFSD_vs_IndSVD = t_total_SeriesFSD/t_total_indSVD; % time ratio

% preprocess time
handle_preprocess_IndSVD = @() preprocess_for_indSVD_eval_ThueM(A, B, tol_numrank);
t_preprocess_IndSVD = timeit(handle_preprocess_IndSVD);

handle_preprocess_Series_FSD = @() seriesFSD(A, B, tol_numrank);
t_preprocess_Series_FSD = timeit(handle_preprocess_Series_FSD);

%%%% Display comparison %%%%
MY_ROW_NAMES = ["std"; "Independent SVD"; "Series-FSD"];
MY_VARIABLE_NAMES = ["Preprocess time", "Evaluation time", "Total time"];
var_preprocess = [0; ..."std"
                   t_preprocess_IndSVD; ..."Independent SVD"
                    t_preprocess_Series_FSD ..."Series-FSD"
                    ];
var_total = [t_std; ... "std"
            t_total_indSVD; ... "Independent SVD"
            t_total_SeriesFSD ..."Series-FSD"
            ];

% calculate evaluation time
var_eval = var_total - var_preprocess;

% create table
table(var_preprocess, var_eval, var_total, ...
    'VariableNames', MY_VARIABLE_NAMES, ...
    'RowNames', MY_ROW_NAMES)

%%%% Conclusions %%%%
if (t_std > t_total_indSVD) & (t_total_indSVD > t_total_SeriesFSD)
    fprintf("Independent SVD improved std -- it took %4.2f%% time in comparison to std.\n", 100 * time_ratio_SVD_vs_std)
    fprintf("Series-FSD further improved Independent SVD -- it took %4.2f%% time in comparison to Independent SVD.\n", 100 * time_ratio_SeriesFSD_vs_IndSVD)
else
    fprintf("Input is too small (matrix size, number of iterations, or both) for the asymptotic time advantages of Independent SVD or Series-FSD to occur -- either std is faster that Independent SVD or Independent SVD is faster than Series-FSD.\n")
end
end