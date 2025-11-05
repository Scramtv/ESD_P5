clc
clear all
close all

load("data.mat")

figure
plot(x80gain.Time/(10^3)-16.766,x80gain.Position, DisplayName="Errormargin = 1")
hold on
plot(x80Gain_0error.Time/(10^3)-39.668,x80Gain_0error.Position, DisplayName="Errormargin = 0")
hold off
grid on
yline(180, DisplayName="Target Angle")
ylabel("Position [degrees]")
xlabel("Time [s]")
title("P regulator with 80.35 Gain - errormargin = 1 vs 0")
xlim([0 4.5])
legend show


