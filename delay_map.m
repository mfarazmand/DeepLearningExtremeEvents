function output = delay_map(X, s, m, numvar, tau)
Y = zeros(numvar*m, 1);
output = zeros(size(Y,1), size(X,1) - tau - (m-1)*s);
for k = 1:size(output,2)
    for j = 1:numvar
        for i = 1:m
            Y((j - 1)*m + i) = X(k + (m - 1)*s - (i - 1)*s, j);
        end
        output(:, k) = Y;
    end
end
end