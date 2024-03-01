function [product] = my_function(N, A, B)
% Calculates Pi_{i=1}^N (A' * A)^i * B * B' iteratively.

% constants
multiplier = (A' * A);

% do computation
factor = (A' * A) * (B * B');
product = 1; % warning: wrong type, should be identity matrix -- will not affect functionality though
for i=1:N
    factor = multiplier * factor;
    product = product * factor;
end
end