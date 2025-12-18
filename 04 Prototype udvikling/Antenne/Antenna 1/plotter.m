clc
clear all
close all

load("Antenne1.mat")
load("Antenna1v.mat")
load("smithdata.mat")



temp = sqrt((Antenne1.Re).^2 + (Antenne1.Im).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Antenne1.Freq/(10^9), s_para, DisplayName="S-11")
grid on
xlim([2.3 2.5])
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
legend show;
title("Measurement of Antenna 1")
hold off

figure
hold on
%plot(Antenne1_Sim.Freq, Antenne1_Sim.S11, DisplayName="S-11")
plot(Smith.Freq, Smith.DB, DisplayName="Simulated")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]")
xlim([2.3 2.5])
legend show;
title("Simulation of Antenna 1")
hold off;

figure
hold on
plot(Antenne1v.Freq, Antenne1v.S11, DisplayName="Simulated")
plot(Antenne1.Freq/(10^9), s_para, DisplayName="Measured")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]")
xlim([2.3 2.5])
legend show;
title("S-11 Antenna 1")
hold off;
