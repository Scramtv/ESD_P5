clc
clear all
close all

load("Antenne1.mat")

temp = sqrt((Antenne1.Re).^2 + (Antenne1.Im).^2);
s_para = 20*log10(temp);

figure
hold on
plot(Antenne1.Freq/(10^9), s_para, DisplayName="S-11")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
legend show;
hold off