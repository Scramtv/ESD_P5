clc
clear all
close all

load("data.mat")

sps = 40e6;

%% 0 dB

I1 = real(RX1_0dB.Ch1)*0.625;
Q1 = imag(RX1_0dB.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

figure
tiledlayout(2, 1)
nexttile
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
hold on
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude [mV]")
xlim([0 100])
ylim([-650 650])
grid on
title("I/Q Signal Plot at 0 dB");
hold off


I2 = real(RX1_0dB.Ch2)*0.625;
Q2 = imag(RX1_0dB.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

nexttile
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
hold on
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
xlabel("Time [µs]")
ylabel("Amplitude [mV]")
xlim([0 100])
ylim([-30 30])
grid on
hold off

%% 19 dB
I2 = real(RX2_19dB.Ch2)*0.625;
Q2 = imag(RX2_19dB.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

figure
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I1")
hold on
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude [mV]")
title("Channel 2 I/Q Signal Plot at 19 dB")
xlim([0 100])
ylim([-650 650])
grid on
hold off

%% 20 dB
I2 = real(RX2_20dB.Ch2)*0.625;
Q2 = imag(RX2_20dB.Ch2)*0.625;

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I2)*10^3));


N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

figure
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I1")
hold on
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude [mV]")
title("Channel 2 I/Q Signal Plot at 20 dB")
xlim([0 100])
ylim([-650 650])
legend
grid on
hold off


