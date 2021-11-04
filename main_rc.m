%% Code for reservoir computing networks

clc; clear; close all;

%% System choice

% Choose which system to work with.
% load('rossler_data.mat') % Rossler
% load('FHN_data.mat') % Fitz-High Nagumo
% load('KF_fourier_data.mat') % Kolmogorov Flow with Fourier mode a(1,0)
load('KF_vorticity_data.mat') % Kolmogorov Flow with vorticity sampling

%% Optional: change variables from default

% If you wish to change tau (prediction time interval), uncomment the following line
% tau = round(value / dt);

% If you wish to change p_train (amount of training noise), uncomment the following line
% p_train = value;

% If you wish to change p_test (amount of testing noise), uncomment the following line
% p_test = value;

% If you wish to change the train/test split, uncomment the following line
% split = value;

% If you wish to change the number of reservoirs, uncomment the following line
% n_reservoir = value;

% If you wish to change the spectral radius, uncomment the following line
% rho = value;

% If you wish to change the least-squares regularization parameter, uncomment the following line
% beta = value;

% If you wish to change the leaking rate, uncomment the following line
% lr = value;

% If you wish to change the input density, uncomment the following line
% i_density = value;

% If you wish to change the reservoir density, uncomment the following line
% r_density = value;

%% Generate training and testing data

[X_train, q_train, X_test, q_test, X_total, q_total] = ...
    format_data(X, q, tau, 1, s, p_train, p_test, split);

%% Training the RC network

% To train the network, run the following code and then main_rc.py. To use 
% a pre-trained network, skip this section and the next.
save(strcat(system,'_train.mat'), 'X_train', 'q_train', 'X_test', 'q_test', ...
    'n_reservoir', 'rho', 'beta', 'lr', 'i_density', 'r_density', 'numvar')

%% Loading predictions

% To load predictions you ran, run the following line. Otherwise, the 
% default predictions are already imported.
load(strcat(system,'_user_predictions.mat'))

%% Calculate error
      
actual = q_test;

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

