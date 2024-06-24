# Series-UMD

This is a MATLAB demo of a new matrix decomposition called Series-UMD (Series Unitarily Minimal Decomposition).
It contains:
1. implementation of the algorithm that constructs Series-UMD,
2. runtime comparison that shows how Series-UMD can speed up matrix computations.


Main files for the above functionalities:
1. (algorithm)
    - main.m -- the main file,
    - display_decomposition.m -- displaying the decomposition,
    - seriesFSD.m -- the core function, constructs Series-UMD.
2. (runtime comparison)
    - ThueM_runtime_comparison_main.m -- compares runtimes,
    - ThueM_equality_validation_main.m -- validates that compared functions output the same results.

`Bonus' files: *live scripts* for the above functionalities:
1. main.mlx,
1. ThueM_runtime_comparison_main.mlx.

Enjoy!
