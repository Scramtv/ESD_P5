clc
clear all
close all

load("matlabdata.mat")

temp11 = sqrt((Meas511.RE).^2 + (Meas511.IM).^2);
s_para11 = 20*log10(temp11);

figure
hold on
plot(Sim5c.x, Sim5c.y, DisplayName= 'Simulated')
plot(Meas510.Freq/(10^9), Meas510.RE, DisplayName="Measured Antenna 3.1") %5.1.0
plot(Meas511.Freq/(10^9), s_para11, DisplayName="Measured Antenna 3.2") %5.1.1

grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
xlim([2.3 2.5])
legend show;
title("Simulation compared to measurement of Antenna 3.1 and 3.2")
hold off