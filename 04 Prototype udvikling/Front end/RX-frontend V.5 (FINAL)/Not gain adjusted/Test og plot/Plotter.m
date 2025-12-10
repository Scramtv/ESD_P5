clc
clear all
close all

load("data.mat")

% Test af Signal generator direkte ind i BladeRF
% Burde få 250kHz ind efter downmixing
sps = 61.44e6;

%% 2442 MHz

I1 = real(x2442MHz_RX1.Ch1);
Q1 = imag(x2442MHz_RX1.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;
disp("2442 MHz input")
fprintf('Maximum amplitude Q1: %.2f m\n', max(Q1)*10^3);
fprintf('Minimum amplitude Q1: %.2f m\n', min(Q1)*10^3);
fprintf('Maximum amplitude I1: %.2f m\n', max(I1)*10^3);
fprintf('Minimum amplitude I1: %.2f m\n', min(I1)*10^3);

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3)*0.625);


I2 = real(x2442MHz_RX2.Ch2);
Q2 = imag(x2442MHz_RX2.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;
fprintf('Maximum amplitude Q2: %.2f m\n', max(Q2)*10^3);
fprintf('Minimum amplitude Q2: %.2f m\n', min(Q2)*10^3);
fprintf('Maximum amplitude I2: %.2f m\n', max(I2)*10^3);
fprintf('Minimum amplitude I2: %.2f m\n', min(I2)*10^3);


fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3)*0.625);

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1, DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1, DisplayName="I1")
grid on
legend
title('Channel 1 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.65 0.65])
hold off

nexttile
plot(T_Q2/(10^-6), Q2, DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2, DisplayName="I2")
grid on
legend
title('Channel 2 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.65 0.65])
hold off



%% 2500 MHz

I1 = real(x2500MHz_RX1.Ch1);
Q1 = imag(x2500MHz_RX1.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

disp("2500 MHz")
fprintf('Maximum amplitude Q1: %.2f m\n', max(Q1)*10^3);
fprintf('Minimum amplitude Q1: %.2f m\n', min(Q1)*10^3);
fprintf('Maximum amplitude I1: %.2f m\n', max(I1)*10^3);
fprintf('Minimum amplitude I1: %.2f m\n', min(I1)*10^3);

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3)*0.625);


I2 = real(x2500MHz_RX2.Ch2);
Q2 = imag(x2500MHz_RX2.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude Q2: %.2f m\n', max(Q2)*10^3);
fprintf('Minimum amplitude Q2: %.2f m\n', min(Q2)*10^3);
fprintf('Maximum amplitude I2: %.2f m\n', max(I2)*10^3);
fprintf('Minimum amplitude I2: %.2f m\n', min(I2)*10^3);

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3)*0.625);

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1, DisplayName="Q1")
hold on
plot(T_I1/(10^-6), I1, DisplayName="I1")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.025 0.025])
hold off

nexttile
plot(T_Q2/(10^-6), Q2, DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2, DisplayName="I2")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.025 0.025])
hold off


%% Noise

I1 = real(xNoise.Ch1);
Q1 = imag(xNoise.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;


disp("Noise")
fprintf('Maximum amplitude Q1: %.2f m\n', max(Q1)*10^3);
fprintf('Minimum amplitude Q1: %.2f m\n', min(Q1)*10^3);
fprintf('Maximum amplitude I1: %.2f m\n', max(I1)*10^3);
fprintf('Minimum amplitude I1: %.2f m\n', min(I1)*10^3);

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3)*0.625);


I2 = real(xNoise.Ch2);
Q2 = imag(xNoise.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude Q2: %.2f m\n', max(Q2)*10^3);
fprintf('Minimum amplitude Q2: %.2f m\n', min(Q2)*10^3);
fprintf('Maximum amplitude I2: %.2f m\n', max(I2)*10^3);
fprintf('Minimum amplitude I2: %.2f m\n', min(I2)*10^3);

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3)*0.625);
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3)*0.625);
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3)*0.625);

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1, DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1, DisplayName="I1")
grid on
legend
title('Channel 1 with no input')
xlabel('Time [µs]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.025 0.025])
hold off

nexttile
plot(T_Q2/(10^-6), Q2, DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2, DisplayName="I2")
grid on
legend
title('Channel 2 with no input')
xlabel('Time [ms]')
ylabel('Amplitude []')
xlim([0 65])
ylim([-0.025 0.025])
hold off