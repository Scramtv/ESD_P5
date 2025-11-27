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
legend
title('Ch1 with Sin input');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
grid on
legend
title('Ch2 with Sin input');
xlabel('Time [s]');
ylabel('Amplitude [?]');





%% Zoom 
figure
tiledlayout(2,1)
nexttile
plot(T_Q1, Q1, DisplayName="Q1");
hold on 
plot(T_I1, I1, DisplayName="I1");
xlim([0.1 0.1+40*10^-6])
grid on
legend
title('Ch1 with Sin input - Zoom');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
xlim([0.1 0.1+40*10^-6])
grid on
legend
title('Ch2 with Sin input - Zoom');
xlabel('Time [s]');
ylabel('Amplitude [?]');

%% Smooth curve - data
% choose query grid: finer and covering both signals
t_min = min([T_Q1(1), T_Q2(1)]);
t_max = max([T_Q1(end), T_Q2(end)]);
tq = t_min : 1/(10*sps) : t_max;   % 10x finer than original for smooth display

% interpolate using 'makima' for smooth curves
Q1q = interp1(T_Q1, Q1, tq, 'makima', NaN);
Q2q = interp1(T_Q2, Q2, tq, 'makima', NaN);

% plot original samples and smooth curves
figure;
plot(T_Q1, Q1, 'o', 'DisplayName', 'Q1 samples'); hold on;
plot(tq, Q1q, '-', 'LineWidth', 1.5, 'DisplayName', 'Q1 smooth');
plot(T_Q2, Q2, 'o', 'DisplayName', 'Q2 samples');
plot(tq, Q2q, '-', 'LineWidth', 1.5, 'DisplayName', 'Q2 smooth');
xlim([0.1 0.1+40e-6]);  % zoom in for detail
grid on;
xlabel('Time [s]');
ylabel('Amplitude');
legend show;
title('Smooth Interpolated Waveforms');
hold off;





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
legend
title('Ch1 Noise');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
grid on
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
grid on
legend
title('Ch1 Noise - Zoom');
xlabel('Time [s]');
ylabel('Amplitude [?]');

nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
xlim([0 0.1])
grid on
legend
title('Ch2 Noise - Zoom');
xlabel('Time [s]');
ylabel('Amplitude [?]');




