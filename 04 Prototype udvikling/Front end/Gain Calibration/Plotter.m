clc
clear all
close all

load("data.mat")

sps = 40e6;

%% 0 dB

I1 = real(RX1_0dB.Ch1);
Q1 = imag(RX1_0dB.Ch1);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

figure
tiledlayout(2, 1)
nexttile
plot(T_I1/(10^-6), I1, DisplayName="I1")
hold on
plot(T_Q1/(10^-6), Q1, DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude []")
xlim([0 100])
ylim([-0.65 0.65])
grid on
title("I/Q Signal Plot at 0 dB");
hold off


I2 = real(RX1_0dB.Ch2);
Q2 = imag(RX1_0dB.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

nexttile
plot(T_I2/(10^-6), I2, DisplayName="I2")
hold on
plot(T_Q2/(10^-6), Q2, DisplayName="Q2")
xlabel("Time [µs]")
ylabel("Amplitude []")
xlim([0 100])
ylim([-0.03 0.03])
grid on
hold off

%% 19 dB
I2 = real(RX2_19dB.Ch2);
Q2 = imag(RX2_19dB.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

figure
plot(T_I2/(10^-6), I2, DisplayName="I1")
hold on
plot(T_Q2/(10^-6), Q2, DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude []")
title("Channel 2 I/Q Signal Plot at 19 dB")
xlim([0 100])
ylim([-0.65 0.65])
grid on
hold off

%% 19 dB
I2 = real(RX2_20dB.Ch2);
Q2 = imag(RX2_20dB.Ch2);

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

figure
plot(T_I2/(10^-6), I2, DisplayName="I1")
hold on
plot(T_Q2/(10^-6), Q2, DisplayName="Q1")
xlabel("Time [µs]")
ylabel("Amplitude []")
title("Channel 2 I/Q Signal Plot at 20 dB")
xlim([0 100])
ylim([-0.65 0.65])
legend
grid on
hold off
