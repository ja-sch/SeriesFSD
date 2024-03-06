function [P] = orth_projector_matrix(M)
% Returns the orthogonal projector on column space of M.
P = M * pinv(M);
end