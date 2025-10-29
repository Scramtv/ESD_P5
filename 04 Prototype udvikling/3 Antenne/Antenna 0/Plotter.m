clc
clear all
close all

load("Antenne0.mat")

temp = sqrt((Antenne0_Meas.Re).^2 + (Antenne0_Meas.Im).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Antenne0_Meas.Freq/(10^9), s_para, DisplayName="S-11")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
legend show;
title("Measurement Antenna 0")
hold off




figure
hold on
plot(Antenne0_Sim.Freq, Antenne0_Sim.S11, DisplayName="S-11")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
legend show;
title("Simulation Antenna 0")
hold off
