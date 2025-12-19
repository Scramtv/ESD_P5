
clc
clear all
close all

load("SNRData.mat")

%% 1 sample

vals_1 = (-50:10:100).';             % column vector of targets (17 x 1)
n_1 = numel(vals_1);

SNR_Delta_1 = nan(n_1,1);            % preallocate (mean DELTA per value)

firstVar_1 = data_SNR_1_sample.Properties.VariableNames{1};
col_1 = data_SNR_1_sample.(firstVar_1);

for k = 1:n_1
    v = vals_1(k);

    % Build logical index depending on column type
    if isnumeric(col_1)
        rows_1 = (col_1 == v);
    else
        rows_1 = (string(col_1) == string(v));
    end

    filtered_1 = data_SNR_1_sample(rows_1, :);

    % Compute mean of DELTA if there are matches; otherwise keep NaN
    if ~isempty(filtered_1)
        SNR_Delta_1(k) = mean(filtered_1.DELTA, 'omitnan');
    end
end

[DELTAmax_1, idxmax_1] = max(SNR_Delta_1);
[DELTAmin_1, idxmin_1] = min(SNR_Delta_1);
xmax_1 = vals_1(idxmax_1);
xmin_1 = vals_1(idxmin_1);

% ----- Second curve: exclude rows where second column is outside [-60, 60] -----
SNR_Delta_1_inrange = nan(n_1,1);                   % new vector (same length/grid)
secondVar_1 = data_SNR_1_sample.Properties.VariableNames{2};
col2_1 = data_SNR_1_sample.(secondVar_1);           % second column values

for k = 1:n_1
    v = vals_1(k);

    % First-column match (same as original)
    if isnumeric(col_1)
        rows_match = (col_1 == v);
    else
        rows_match = (string(col_1) == string(v));
    end

    % Second-column in-range mask [-60, 60]
    if isnumeric(col2_1)
        inRange = (col2_1 >= -60) & (col2_1 <= 60);
    else
        col2_num = str2double(string(col2_1));      % convert text to numeric, NaN if not numeric
        inRange = (col2_num >= -60) & (col2_num <= 60);
    end

    rows_both = rows_match & inRange;

    filtered_1_inrange = data_SNR_1_sample(rows_both, :);

    if ~isempty(filtered_1_inrange)
        SNR_Delta_1_inrange(k) = mean(filtered_1_inrange.DELTA, 'omitnan');
    end
end

% (Optional) extrema for the in-range curve
[DELTAmax_1_in, idxmax_1_in] = max(SNR_Delta_1_inrange);
[DELTAmin_1_in, idxmin_1_in] = min(SNR_Delta_1_inrange);
xmax_1_in = vals_1(idxmax_1_in);
xmin_1_in = vals_1(idxmin_1_in);


figure
plot(vals_1, SNR_Delta_1, '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', "180 degree accuracy")
hold on
plot(vals_1, SNR_Delta_1_inrange, '--s', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', "120 degree accuracy")
plot(xmin_1,   DELTAmin_1,   'kv', 'MarkerFaceColor','k', 'MarkerSize', 9, 'DisplayName', "Min Δ ([-90, 90]) = 5.08")
plot(xmax_1,   DELTAmax_1,   'r^', 'MarkerFaceColor','r', 'MarkerSize', 9, 'DisplayName', "Max Δ ([-90, 90]) = 56.66")
plot(xmin_1_in,DELTAmin_1_in,'bo', 'MarkerFaceColor','b', 'MarkerSize', 9, 'DisplayName', "Min Δ ([-60, 60]) = 0.12")
plot(xmax_1_in,DELTAmax_1_in,'ms', 'MarkerFaceColor','m', 'MarkerSize', 9, 'DisplayName', "Max Δ ([-60, 60]) = 45.89")
xlim([-55 105])
grid on
ylabel("Delta")
xlabel("SNR [dB]")
title("SNR vs Delta — Sample Size 1")
legend('Location','best')




%% Sample 900

vals_1 = (-50:10:100).';             % column vector of targets (17 x 1)
n_1 = numel(vals_1);

SNR_Delta_1 = nan(n_1,1);            % preallocate (mean DELTA per value)

firstVar_1 = data_SNR_900_sample.Properties.VariableNames{1};
col_1 = data_SNR_900_sample.(firstVar_1);

for k = 1:n_1
    v = vals_1(k);

    % Build logical index depending on column type
    if isnumeric(col_1)
        rows_1 = (col_1 == v);
    else
        rows_1 = (string(col_1) == string(v));
    end

    filtered_1 = data_SNR_900_sample(rows_1, :);

    % Compute mean of DELTA if there are matches; otherwise keep NaN
    if ~isempty(filtered_1)
        SNR_Delta_1(k) = mean(filtered_1.DELTA, 'omitnan');
    end
end

[DELTAmax_1, idxmax_1] = max(SNR_Delta_1);
[DELTAmin_1, idxmin_1] = min(SNR_Delta_1);
xmax_1 = vals_1(idxmax_1);
xmin_1 = vals_1(idxmin_1);

% ----- Second curve: exclude rows where second column is outside [-60, 60] -----
SNR_Delta_1_inrange = nan(n_1,1);                   % new vector (same length/grid)
secondVar_1 = data_SNR_900_sample.Properties.VariableNames{2};
col2_1 = data_SNR_900_sample.(secondVar_1);           % second column values

for k = 1:n_1
    v = vals_1(k);

    % First-column match (same as original)
    if isnumeric(col_1)
        rows_match = (col_1 == v);
    else
        rows_match = (string(col_1) == string(v));
    end

    % Second-column in-range mask [-60, 60]
    if isnumeric(col2_1)
        inRange = (col2_1 >= -60) & (col2_1 <= 60);
    else
        col2_num = str2double(string(col2_1));      % convert text to numeric, NaN if not numeric
        inRange = (col2_num >= -60) & (col2_num <= 60);
    end

    rows_both = rows_match & inRange;

    filtered_1_inrange = data_SNR_900_sample(rows_both, :);

    if ~isempty(filtered_1_inrange)
        SNR_Delta_1_inrange(k) = mean(filtered_1_inrange.DELTA, 'omitnan');
    end
end

% (Optional) extrema for the in-range curve
[DELTAmax_1_in, idxmax_1_in] = max(SNR_Delta_1_inrange);
[DELTAmin_1_in, idxmin_1_in] = min(SNR_Delta_1_inrange);
xmax_1_in = vals_1(idxmax_1_in);
xmin_1_in = vals_1(idxmin_1_in);


figure
plot(vals_1, SNR_Delta_1, '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', "180 degree accuracy")
hold on
plot(vals_1, SNR_Delta_1_inrange, '--s', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', "120 degree accuracy")
plot(xmin_1,   DELTAmin_1,   'kv', 'MarkerFaceColor','k', 'MarkerSize', 9, 'DisplayName', "Min Δ ([-90, 90]) = 5.08")
plot(xmax_1,   DELTAmax_1,   'r^', 'MarkerFaceColor','r', 'MarkerSize', 9, 'DisplayName', "Max Δ ([-90, 90]) = 56.66")
plot(xmin_1_in,DELTAmin_1_in,'bo', 'MarkerFaceColor','b', 'MarkerSize', 9, 'DisplayName', "Min Δ ([-60, 60]) = 0.12")
plot(xmax_1_in,DELTAmax_1_in,'ms', 'MarkerFaceColor','m', 'MarkerSize', 9, 'DisplayName', "Max Δ ([-60, 60]) = 45.89")
xlim([-55 105])
grid on
ylabel("Delta")
xlabel("SNR [dB]")
title("SNR vs Delta — Sample Size 900")
legend('Location','best')
