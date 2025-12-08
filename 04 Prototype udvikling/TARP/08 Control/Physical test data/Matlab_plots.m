clc
clear all
close all

load("data.mat")

% figure
% plot(x80gain.Time/(10^3)-16.766,x80gain.Position, DisplayName="Errormargin = 1")
% hold on
% plot(x80Gain_0error.Time/(10^3)-39.668,x80Gain_0error.Position, DisplayName="Errormargin = 0")
% hold off
% grid on
% yline(180, DisplayName="Target Angle")
% ylabel("Position [degrees]")
% xlabel("Time [s]")
% title("P regulator with 80.35 Gain - errormargin = 1 vs 0")
% xlim([0 4.5])
% legend show
% 
% 
% figure
% plot(x80gain.Time/(10^3)-16.766,x80gain.Position, DisplayName="80.35 Gain")
% hold on
% plot(x3_73Gain.Time/(10^3)-16.509,x3_73Gain.Position, DisplayName="3.73 Gain")
% hold off
% grid on
% yline(180, DisplayName="Target Angle")
% ylabel("Position [degrees]")
% xlabel("Time [s]")
% title("P regulator with 80.35 vs 3.73 Gain ")
% xlim([0 4.5])
% legend show


figure
plot(Azi_24_83Gain.Time/(10^3)-77.950,Azi_24_83Gain.Position, DisplayName="24.83 Gain")
hold on
plot(x3_73Gain.Time/(10^3)-16.509,x3_73Gain.Position, DisplayName="3.73 Gain")
hold off
grid on
yline(180, DisplayName="Target Angle")
ylabel("Position [degrees]")
xlabel("Time [s]")
title("P regulator with 24.83 vs 3.73 Gain ")
xlim([0 4.5])
legend show


figure
plot(Azi_24_83Gain.Time/(10^3)-77.950,Azi_24_83Gain.Position, DisplayName="Azimut")
hold on
plot(Tilt_4_32_Gain.Time/(10^3)-76.409,Tilt_4_32_Gain.Position, DisplayName="Tilt")
hold off
grid on
yline(180, DisplayName="Target Angle")
ylabel("Position [degrees]")
xlabel("Time [s]")
title("P regulator with 24.83 vs 3.73 Gain ")
% xlim([0 4.5])
legend show
