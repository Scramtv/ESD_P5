clc
clear all
close all

load("data.mat")



figure
plot(Q4_U10_10k_res.Time/10^(-6),Q4_U10_10k_res.V1, DisplayName="PMOS")
hold on
plot(Q4_U10_10k_res.Time/10^(-6),Q4_U10_10k_res.V2, DisplayName="NMOS")
% hold on
% plot(Q4_U10_1k_res.Time/10^(-6),Q4_U10_1k_res.V1, DisplayName="PMOS + 1K")
% hold on
% plot(Q4_U10_1k_res.Time/10^(-6),Q4_U10_1k_res.V2, DisplayName="NMOS + 1K")
grid on
xlabel("Time [µs]")
ylabel("Voltage [V]")
title("H-Bridge Short Circuit Issue")
xlim([-10 10])
legend show
hold off


figure
plot(BJT_Issue_BC546.Time/10^(-6),BJT_Issue_BC546.V1, DisplayName="Issue Base")
hold on
plot(BJT_Issue_BC546.Time/10^(-6),BJT_Issue_BC546.V2, DisplayName="Issue Collector")
% hold on
% plot(BJT_10K_res.Time/10^(-6),BJT_10K_res.V1, DisplayName="10k Base")
% hold on
% plot(BJT_10K_res.Time/10^(-6),BJT_10K_res.V2, DisplayName="10K Collector")
% hold on
% plot(BJT_10pF_cap.Time/10^(-6),BJT_10pF_cap.V1, DisplayName="10pF Base")
% hold on
% plot(BJT_10pF_cap.Time/10^(-6),BJT_10pF_cap.V2, DisplayName="10pF Collector")
grid on
xlabel("Time [µs]")
ylabel("Voltage [V]")
title("BJT: Collector Voltage vs. Base Voltage")
xlim([-2 3])
ylim([-2 14])
legend show
hold off


