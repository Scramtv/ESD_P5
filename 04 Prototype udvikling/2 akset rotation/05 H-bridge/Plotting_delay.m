clc
clear all
close all

load("data.mat")

figure
plot(Q3_U9_delay.Time/10^(-6),Q3_U9_delay.V1, DisplayName="V1")
hold on
plot(Q3_U9_delay.Time/10^(-6),Q3_U9_delay.V2, DisplayName="V2")
grid on
xlabel("Time [µs]")
xlim([-1 6])
legend show
hold off

figure
plot(Q4_U10_delay_fix.Time/10^(-6),Q4_U10_delay_fix.V1, DisplayName="V1")
hold on
plot(Q4_U10_delay_fix.Time/10^(-6),Q4_U10_delay_fix.V2, DisplayName="V2")
grid on
xlabel("Time [µs]")
 xlim([-1 6])
legend show
hold off



figure
plot(Q4_U10_fixed1.Time/10^(-6),Q4_U10_fixed1.V1, DisplayName="V1")
hold on
plot(Q4_U10_fixed1.Time/10^(-6),Q4_U10_fixed1.V2, DisplayName="V2")
grid on
xlabel("Time [µs]")
 xlim([-1 6])
legend show
hold off

% does not matter

% figure
% plot(ShortCircuit.Time,ShortCircuit.V1, DisplayName="V1")
% hold on
% plot(ShortCircuit.Time,ShortCircuit.V2, DisplayName="V2")
% grid on
% legend show
% hold off

