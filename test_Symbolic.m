%%%% Test 1: noncommutativity
%%% 1.1 dimension 1
% Create input
A = symmatrix('A', [2 2])
B = symmatrix('B', [2 2])
Assb = SymbolicSingleBlock(A)
Bssb = SymbolicSingleBlock(B)
% Do test 1/3
Assb * Bssb - Bssb * Assb
% Test outcome: passed.

% prepare for tests2-3/3
zerossb = SymbolicSingleBlock(0 * symmatrix('A', [2 2]))

% Do test 2/3: more * and +
a_bit_like_multidim_1 = (Assb * Bssb + Assb * zerossb) - ...
(Bssb * Assb + zerossb * zerossb)
% Test outcome: passed.

% Do test 3/3 : indexing
indexing_test_cell = {a_bit_like_multidim_1}
indexing_text_ssb = indexing_test_cell{1,1}
indexing_text_ssb_new = indexing_text_ssb * indexing_text_ssb
% Test outcome: FAILED.
