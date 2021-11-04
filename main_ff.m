%% Code for feedforward networks

clc; clear; close all;

%% System choice

% Choose which system to work with.
% load('rossler_data.mat') % Rossler
% load('fhn_data.mat') % Fitz-High Nagumo
load('KF_fourier_data.mat') % Kolmogorov Flow with Fourier mode a(1,0)
% load('KF_vorticity_data.mat') % Kolmogorov Flow with vorticity sampling

%% Optional: change variables from default

% If you wish to change tau (prediction time interval), uncomment the following line
% tau = round(value / dt);

% If you wish to change m (number of time delay embeddings), uncomment the following line
% m = round(value / dt);

% If you wish to change s (step size in delays), uncomment the following line
% s = value;

% If you wish to change p_train (amount of training noise), uncomment the following line
% p_train = value;

% If you wish to change p_test (amount of testing noise), uncomment the following line
% p_test = value;

% If you wish to change the train/test split, uncomment the following line
% split = value;

% If you wish to change the number of layers and/or nodes per layer, uncomment the following line
% ff_layers = [nodes1 nodes2 ... nodesn]

%% Generate training and testing data

[X_train, q_train, X_test, q_test, X_total, q_total] = ...
    format_data(X, q, tau, m, s, p_train, p_test, split);

%% Load pre-trained network, or train a new network

% To train the network, run the following code. A pre-trained network is
% already loaded. To use that instead, skip this section.

% ff_net = feedforwardnet(ff_layers);
% ff_net = train(ff_net, X_train, q_train);
% save('ff_net.mat', 'ff_net');

% If you wish to load your own trained network, uncomment the following line
% ff_net = load("network_name.mat");

%% Make predictions from trained network

prediction = ff_net(X_test);
actual = q_test;
        
%% Calculate error
        
% RMSE
rmse = sqrt(sum((actual - prediction).^2)/length(actual));
nrmse = rmse/std(actual);

% AUC
classification = actual > q_e;
posclass = 1;
[recall,precision,T,AUC] = perfcurve(classification, prediction, posclass, 'xcrit', 'reca', 'ycrit', 'prec');

%% Generate figures

% plot AUC
figure(1);
hold on; box on;
plot(recall, precision, 'linewidth', 2);
set(gca, 'defaulttextinterpreter', 'latex', 'fontsize', 20);
xlabel("Recall");
ylabel("Precision");

% plot time series
figure(2);
hold on; box on;
plot(actual, 'linewidth', 2);
plot(prediction, '--', 'linewidth', 2);
set(gca, 'defaulttextinterpreter', 'latex', 'fontsize', 20);
xlabel("Time");
ylabel("Quantity of Interest");

% plot predicted vs. true value plot
figure(3);
hold on; box on;
plot(prediction, actual, '.');
set(gca,'defaulttextinterpreter', 'latex', 'fontsize', 20);
xlabel("Predicted Value");
ylabel("True Value");

