clc
clear all
close all

load("Antenne0.mat")

temp = sqrt((Antenne0_data.Real).^2 + (Antenne0_data.Imag).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Antenne0_data.Freq/(10^9), s_para, DisplayName="S-11")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
legend show;
hold off