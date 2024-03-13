n = 2;
m = 5;

y = [[1.8, 2.5]; [2.0, 1.7]; [1.5, 1.5]; [1.5, 2.0]; [2.5, 1.5]];
y = y';
d = [2.00; 1.24; 0.59; 1.31; 1.44];

A = zeros(m, n + 1);
b = zeros(m, 1);
for i = 1:m
    A(i, :) = [-2 * y(:, i)' 1];
    b(i) = d(i) - power(norm(y(:, i)), 2);
end
Q = [[1, 0, 0]; [0, 1, 0]; [0, 0, 0]];
c = [0; 0; -1/2];

cvx_begin sdp
    variables miu t
    minimize t - power(norm(b), 2)
    expression M(4,4) 
    M(1:3, 1:3) = A' * A + miu * Q;
    M(1:3, 4) = A' * b - miu * c;
    M(4, 1:3) = (A' * b - miu * c)';
    M(4, 4) = t;
    subject to
        M >= 0
cvx_end

syms x1 x2
eqn = (A' * A + miu * Q) * [x1;x2;[x1;x2]' * [x1;x2]] == A' * b - miu * c;
S = solve(eqn, [x1;x2]);
