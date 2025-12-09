% --- Load data (optional if already in workspace) ---
% data = readtable('antenna4.csv');
% Antenna4 = data;

% --- Initialize plot data ---
x = Antenna4.Freq;   % Frequency in GHz
y = Antenna4.dB;     % S11 (in dB)

load("matlab4sim.mat")

figure;
hold on;
plot(Antenna4.x,Antenna4.y, 'DisplayName', 'Simulated')
plot(Antenne4.x, Antenna4.y, 'DisplayName', 'Measured');
grid on;
ylabel('S-11 [dB]');
xlabel('Frequency [GHz]');
legend show;
title('Measurement of Antenna 1');
hold off;
