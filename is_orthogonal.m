function [test_result, error_message] = is_orthogonal(M, tol)
% Orthogonality test, up to given tolerance.
% First checks if matrix is square. If it is, checks max abs diff
%   Detailed explanation goes here
    sizeM = size(M);
    assert(sizeM(1) == sizeM(2), "Input matrix is not square")
    tested_value_orth = max(max(abs(M * M' - eye(sizeM(1)))));
    condition_orth = tested_value_orth < tol;
    assert(condition_orth, "Input matrix not orthogonal (it is square though)")
    test_result = condition_orth
    error_message = "Not supported for now"
end