clc
clear all
close all

load("Antenna5.mat")

temp = sqrt((Meas5.RE).^2 + (Meas5.IM).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Sim5.x, Sim5.y, DisplayName= 'Simulated')
plot(Meas5.Freq/(10^9), s_para, DisplayName="Measured")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
xlim([2.3 2.5])
legend show;
title("Simulation compared to measurement of Antenna 3")
hold off