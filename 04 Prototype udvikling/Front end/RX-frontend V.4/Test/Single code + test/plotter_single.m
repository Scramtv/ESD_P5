clc
clear all
close all

% Test af Signal generator direkte ind i BladeRF
% Får 250kHz ind efter downmixing
load("Data.mat")
sps = 1.44e6;

Q1 = real(RF2442MHz.Complex);
I1 = imag(RF2442MHz.Complex);

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

Q2 = real(NoRF.Complex);
I2 = imag(NoRF.Complex);

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
xlim([0 0.6])
title('Signal with input');
xlabel('Time [µs]');
ylabel('Amplitude [mV]');


%Støj signal generator sendte ud.
nexttile
plot(T_Q2, Q2, DisplayName="Q2");
hold on 
plot(T_I2, I2, DisplayName="I2");
grid on
legend
xlim([0 0.6]);
title('Noise from signal generator');
xlabel('Time [s]');
ylabel('Amplitude [mV]');


figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1, DisplayName="Q1");
hold on 
plot(T_I1/(10^-6), I1, DisplayName="I1");
grid on
legend
xlim([0 40])
title('Signal with input zoomed');
xlabel('Time [µs]');
ylabel('Amplitude [mV]');


%Støj signal generator sendte ud.
nexttile
plot(T_Q2/(10^-6), Q2, DisplayName="Q2");
hold on 
plot(T_I2/(10^-6), I2, DisplayName="I2");
grid on
legend
xlim([0 40]);
title('Noise from signal generator zoomed');
xlabel('Time [s]');
ylabel('Amplitude [mV]');




