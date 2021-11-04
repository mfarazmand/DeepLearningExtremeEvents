function [X_train, q_train, X_test, q_test, X_total, q_total] = ...
    format_data(X, q, tau, m, s, p_train, p_test, split)
% Segments, adds noise, and adds delays to the input training, testing, and total data.
%   X: obervables, size variables x time
%   q: quantity of interest, size 1 x time
%   trainTestRatio: amount of total data allotted as training data
%   p: percent standard deviation noise to testing data
%   tau: prediction time
%   m: number of time delays (including current time itself)
%   s: index step size between time delays

% Segment data
trainTestRatio = split;
trainTestSplit = round(trainTestRatio * size(X, 2));
X_train_seg = X(:, 1:trainTestSplit);
X_test_seg = X(:, 1+trainTestSplit:end);
q_train_seg = q(1:trainTestSplit);
q_test_seg = q(1 + trainTestSplit:end);

% Add noise
sig = std(X_train_seg, 0, 2); % 2nd arg weights, 3rd arg with respect to 2nd variable
X_train_noise = X_train_seg + randn(size(X_train_seg)) .* sig * p_train;
% X_train_noise = X_train_seg + [zeros(size(X_train_seg, 1), 140000), randn(size(X_train_seg) - [0, 140000]) .* sig * p];
X_test_noise = X_test_seg + randn(size(X_test_seg)) .* sig * p_test;
% X_test_noise = X_test_seg + [zeros(size(X_test_seg, 1), 8500), randn(size(X_test_seg) - [0, 8500]) .* sig * p];
X_total_noise = [X_train_noise, X_test_noise];

% Delay data
numInputs = size(X, 1);
X_train_del = delay_map(X_train_noise', s, m, numInputs, tau);
q_train_del = q_train_seg((1 + tau + (m-1)*s):end);
X_test_del = delay_map(X_test_noise', s, m, numInputs, tau);
q_test_del = q_test_seg((1 + tau + (m-1)*s):end);
X_total_del = delay_map(X_total_noise', s, m, numInputs, tau);
q_total_del = q((1 + tau + (m-1)*s):end);

% Name outputs
X_train = X_train_del;
q_train = q_train_del;
X_test = X_test_del;
q_test = q_test_del;
X_total = X_total_del;
q_total = q_total_del;

end

