function g = hgrad(w, x, S, a, b, pltfn)

% w = un-mixing matrix in M*K-vector
% x = mixed signal data (size K x ndata)
% g = estimated output entropy gradient

% unpack W
[M, n] = size(x);
K = length(w) / M;
W = reshape(w, K, M);
a = a(:, ones(1, n));
b = b(:, ones(1, n));

% form output data set
y = W*x;
t = tanh(y);
e = exp(-0.5*y.^2);

tiny=1e-12;
dY = a/sqrt(pi).*e + b.*(1 - t.^2) + tiny;
ddY = -a/sqrt(pi).*y.*e - 2*b.*t.*(1 - t.^2);

Z = ddY./dY; %%%%%%%%%%%%%%%%%%%%%%%%%%%% NB: divide by zero occurs here.

clear a b t e dY ddY;

g1 = zeros(K, M);
for i = 1:K
	for j = 1:M
		g1(i, j) = 1/n*sum(Z(i, :).*x(j, :));
	end
end

g2 = ((S*W')*inv(W*S*W'))';

g = -reshape(g1+g2, K, M);