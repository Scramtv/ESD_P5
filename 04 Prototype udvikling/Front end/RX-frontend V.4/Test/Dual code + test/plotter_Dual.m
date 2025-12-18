clc
clear all
close all

% Test af Signal generator direkte ind i BladeRF
% Får 250kHz ind efter downmixing
load("Data.mat")
sps = 1.44e6;

Q1 = real(RF2442MHz.Ch1);
I1 = imag(RF2442MHz.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

Q2 = real(RF2442MHz.Ch2);
I2 = imag(RF2442MHz.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;



%% Full data

figure
tiledlayout(2,1)
nexttile
plot(T_Q1, Q1, DisplayName="Q1");
hold on 
plot(T_I1, I1, DisplayName="I1");
grid on
xlim([0 0.4])
legend
title('Ch1 with Sin input');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
grid on
xlim([0 0.4])
legend
title('Ch2 with Sin input');
xlabel('Time [s]');
ylabel('Amplitude [?]');





%% Zoom
tmin = 0.1;
tmax = 0.1 + 40e-6;

idx1 = T_Q1 >= tmin & T_Q1 <= tmax;
idx2 = T_Q2 >= tmin & T_Q2 <= tmax;

figure
tiledlayout(2,1)

nexttile
plot(T_Q1(idx1), Q1(idx1), DisplayName="Q1");
hold on
plot(T_I1(idx1), I1(idx1), DisplayName="I1");
xlim([tmin 0.10004])
ylim([-0.5 0.5])
grid on
legend
title('Ch1 with Sin input - Zoom')
xlabel('Time [s]')
ylabel('Amplitude [?]')

nexttile
plot(T_Q2(idx2), Q2(idx2), DisplayName="Q2");
hold on
plot(T_I2(idx2), I2(idx2), DisplayName="I2");
xlim([tmin 0.10004])
ylim([-0.5 0.5])
grid on
legend
title('Ch2 with Sin input - Zoom')
xlabel('Time [s]')
ylabel('Amplitude [?]')


%% Smooth curve - data

% zoom window
xwin = [0.1 0.1+40e-6];

% Q signals
maskQ1 = T_Q1 >= xwin(1) & T_Q1 <= xwin(2);
maskQ2 = T_Q2 >= xwin(1) & T_Q2 <= xwin(2);

tq_Q = linspace(xwin(1), xwin(2), 10*max(nnz(maskQ1),1));

Q1q = interp1(T_Q1(maskQ1), Q1(maskQ1), tq_Q, 'makima');
Q2q = interp1(T_Q2(maskQ2), Q2(maskQ2), tq_Q, 'makima');

% I signals
maskI1 = T_I1 >= xwin(1) & T_I1 <= xwin(2);
maskI2 = T_I2 >= xwin(1) & T_I2 <= xwin(2);

tq_I = linspace(xwin(1), xwin(2), 10*max(nnz(maskI1),1));

I1q = interp1(T_I1(maskI1), I1(maskI1), tq_I, 'makima');
I2q = interp1(T_I2(maskI2), I2(maskI2), tq_I, 'makima');

% plot original samples and smooth curves
figure
tiledlayout(2, 1)

nexttile
plot(T_Q1, Q1, 'ro', DisplayName = 'Q1 samples')
hold on
plot(tq_Q, Q1q, '-', 'LineWidth', 1.5, DisplayName = 'Q1 smooth')
plot(T_I1, I1, 'bo', DisplayName = 'I1 samples')
plot(tq_I, I1q, '-', 'LineWidth', 1.5, DisplayName = 'I1 smooth')
xlim(xwin)
grid on
xlabel('Time [s]')
ylabel('Amplitude [?]')
legend('Location','eastoutside')
hold off

nexttile
plot(T_Q2, Q2, 'ro', DisplayName = 'Q2 samples')
hold on
plot(tq_Q, Q2q, '-', 'LineWidth', 1.5, DisplayName = 'Q2 smooth')
plot(T_I2, I2, 'bo', DisplayName = 'I2 samples')
plot(tq_I, I2q, '-', 'LineWidth', 1.5, DisplayName = 'I2 smooth')
xlim(xwin)
grid on
xlabel('Time [s]')
ylabel('Amplitude [?]')
legend('Location','eastoutside')
hold off

%% Full data - Noise

Q1 = real(NoRF.Ch1);
I1 = imag(NoRF.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

Q2 = real(NoRF.Ch2);
I2 = imag(NoRF.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

figure
tiledlayout(2,1)
nexttile
plot(T_Q1, Q1, DisplayName="Q1");
hold on 
plot(T_I1, I1, DisplayName="I1");
grid on
xlim([0 0.4])
legend
title('Ch1 Noise');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
grid on
xlim([0 0.4])
legend
title('Ch2 Noise');
xlabel('Time [s]');
ylabel('Amplitude [?]');





%% Zoom 
figure
tiledlayout(2,1)
nexttile
plot(T_Q1, Q1, DisplayName="Q1");
hold on 
plot(T_I1, I1, DisplayName="I1");
xlim([0 0.1])
ylim([-10*10^-3 10*10^-3])
grid on
legend
title('Ch1 Noise');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
xlim([0 0.1])
ylim([-0.045 0.045])
grid on
legend
title('Ch2 Noise');
xlabel('Time [s]');
ylabel('Amplitude [?]');




