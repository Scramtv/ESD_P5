% --- Initialize plot data ---
%x = Antennac.Freq;   % Frequency in GHz
%y = Antennac.dB;     % S11 (in dB)

load("matlabny.mat")

figure;
hold on;
plot(Gertsantennes_11.x,Gertsantennes_11.y, 'DisplayName', 'Simulated')
grid on;
ylabel('S-11 [dB]');
xlabel('Frequency [GHz]');
legend show;
title('Simulation of calculated Antenna');
hold off;
