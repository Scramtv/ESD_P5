clc
clear all
close all

load("DeltaData.mat")

%% Plot 1
[Deltamax, idxmax] = max(data_clean.DELTA);
[Deltamin, idxmin] = min(data_clean.DELTA);
xmax = data_clean.THETA_REF(idxmax);
xmin = data_clean.THETA_REF(idxmin);

figure
plot(data_clean.THETA_REF, data_clean.DELTA, DisplayName="Delta")
hold on
plot(xmax, Deltamax,'ro','MarkerFaceColor','r','MarkerSize',8, DisplayName = "Max delta = 0.1")
plot(xmin, Deltamin,'ko','MarkerFaceColor','k','MarkerSize',8, DisplayName = "Min delta = 0.0")
xlim([-95 95])
ylim([-0.01 0.11])
xlabel('Theta_{Ref}');
ylabel('Delta');
title('Delta vs Theta Reference - Ideal Sine Wave');
legend;
grid on



%% Plot 2

[Deltamax, idxmax] = max(data_lower_sample_size.DELTA);
[Deltamin, idxmin] = min(data_lower_sample_size.DELTA);
xmax = data_lower_sample_size.THETA_REF(idxmax);
xmin = data_lower_sample_size.THETA_REF(idxmin);

figure
plot(data_lower_sample_size.THETA_REF, data_lower_sample_size.DELTA*10^3, DisplayName="Delta")
hold on
plot(xmax, Deltamax*10^3,'ro','MarkerFaceColor','r','MarkerSize',8, DisplayName = "Max delta = 1.1*10^{-3}")
plot(xmin, Deltamin*10^3,'ko','MarkerFaceColor','k','MarkerSize',8, DisplayName = "Min delta = 13*10^{-6}")
xlim([-95 95])
ylim([-0.1 1.2])
xlabel('Theta_{Ref}');
ylabel('Delta*10^{-3}');
title('Delta vs Theta Reference - Sample Size 1');
legend;
grid on

%% Plot 3

[Deltamax, idxmax] = max(data_higher_theta.DELTA);
[Deltamin, idxmin] = min(data_higher_theta.DELTA);
xmax = data_higher_theta.THETA_REF(idxmax);
xmin = data_higher_theta.THETA_REF(idxmin);

figure
plot(data_higher_theta.THETA_REF, data_higher_theta.DELTA*10^3, DisplayName="Delta")
hold on
plot(xmax, Deltamax*10^3,'ro','MarkerFaceColor','r','MarkerSize',8, DisplayName = "Max delta = 1.1*10^{-3}")
plot(xmin, Deltamin*10^3,'ko','MarkerFaceColor','k','MarkerSize',8, DisplayName = "Min delta = 13*10^{-6}")
xlim([-95 95])
ylim([-0.1 1.2])
xlabel('Theta_{Ref}');
ylabel('Delta*10^{-3}');
title('Delta vs Theta Reference - Higher Resolution');
legend;
grid on




