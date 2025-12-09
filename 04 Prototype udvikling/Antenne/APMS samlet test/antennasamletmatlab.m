clc
clear all
close all

load("matlab.data.mat")

load("Antenna5.mat")

temp = sqrt((Meas5.RE).^2 + (Meas5.IM).^2);
s_para = 20*log10(temp);

%temp = sqrt((Meas5.RE).^2 + (Meas5.IM).^2);
%s_para = 20*log10(temp);


figure
hold on
plot(Meas5.Freq, s_para, DisplayName="Antenna 3")
plot(x510.Freq, x510.DB, DisplayName='Antenna 3.1')
plot(x511.freq, x511.dB, DisplayName="Antenna 3.2")
grid on
ylabel("S-11 [dB]")
xlabel("Frequency [GHz]");
%xlim([2.3 2.5])
legend show;
title("Measurement of Antenna 3, 3.1 and 3.2")
hold off