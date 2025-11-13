clc
clear all
close all

load("Antenna4.mat")

temp = sqrt((Meas4.RE).^2 + (Meas4.IM).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Sim4.x, Sim4.y, DisplayName= 'Simulated')
plot(Meas4.Freq/(10^9), s_para, DisplayName="Measured")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
xlim([2.3 2.5])
legend show;
title("Simulation compared to measurement of Antenna 4")
hold off


