clc
clear all
close

data = readtable('data_sample_size_monte_carlo.txt');
N = data.N;
theta = data.THETA_MEAS;

%% Unique N values
N_unique = unique(N);

mean_theta = zeros(size(N_unique));
var_theta  = zeros(size(N_unique));

%% Compute mean and variance for each N
for i = 1:length(N_unique)
    idx = N == N_unique(i);
    mean_theta(i) = mean(theta(idx));
    var_theta(i)  = var(theta(idx));
end

%% Find N with minimum variance
[~, minVarIdx] = min(var_theta);
N_minVar = N_unique(minVarIdx);

idx_minVar = N == N_minVar;

%% Plot
figure; hold on; grid on;

% 1. Scatter plot of all measurements
scatter(N, theta, 15, 'b', 'filled', 'MarkerFaceAlpha', 0.3);

% 2. Mean THETA_MEAS for each N
plot(N_unique, mean_theta, 'o', ...
     'MarkerSize', 7, ...
     'MarkerFaceColor', 'r');

% 3. Highlight lowest-variance dataset
scatter(N(idx_minVar), theta(idx_minVar), ...
        40, 'r', 'filled');


%% Labels and legend
xlabel('N');
ylabel('\theta_{meas}');
title('\theta_{meas} vs N - Mean \Delta and Minimum Variance Highlighted');

legend( ...
    'All \theta_{meas} samples', ...
    'Mean \theta_{meas} per N', ...
    sprintf('Samples at N = %d (min variance)', N_minVar), ...
    'Location', 'best' ...
);

hold off;