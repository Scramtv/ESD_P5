clc
clear all
close all


load("data.mat")

%% ------- Transferfunctions ----------------------------
s=tf('s');
sys_azi=(17.63*10^3)/(s*((7.73*s+3.97)*(724.31+1.88*s)+17.63*810.90));
sys_tilt=(404.91* 10^3)/(s*((15.44*s + 5.16)*(6.73* 10^3 + 3.87*s) + 404.91*285.57));

d_azi=24.83;
d_tilt=4.32;

CL_azi=(d_azi*sys_azi)/(1+d_azi*sys_azi);
CL_tilt=(d_tilt*sys_tilt)/(1+d_tilt*sys_tilt);



%% ------- plot for TARP motor code V3.3 -----------------
x_azi = (0:numel(x24_83TiltGain)-1)*10^(-4);
x_tilt = (0:numel(x4_32AziGain)-1)*10^(-4);
figure
plot(x_azi,x4_32AziGain.Position, DisplayName="Azimut")
hold on
plot(x_tilt,x24_83TiltGain.Position, DisplayName="Tilt")
hold off
grid on
yline(180,color='black', DisplayName="Target Angle Azimut")
yline(160, color = 'green', DisplayName="Target Angle Tilt")
ylabel("Position [degrees]")
xlabel("Time [s]")
title("P regulator Tilt vs Azimut")
% xlim([0 4.5])
legend show




%% ------- Azi plot - simulated vs reality -------------------
% --- Real data ---
x_azi = (0:numel(x24_83TiltGain)-1)' * 1e-4;
real_data = x4_32AziGain.Position(:);

Ts = 1e-4;                 % same as real data
t_azi = 0:Ts:x_azi(end);   % simulation time vector
u = 180 * ones(size(t_azi));   % step input

azi_sim = lsim(CL_azi, u, t_azi);

% --- Plot ---
figure
plot(x_azi, real_data, 'DisplayName','Reality')
hold on
plot(t_azi, azi_sim, 'DisplayName','Simulated')
yline(180, 'DisplayName','Target')
grid on
xlabel('Time [s]')
ylabel('Position [degrees]')
xlim([0, 6])
ylim([0, 300])
legend show
title('Azimuth P regulator: simulated vs reality')


%% ------- Tilt plot - simulated vs reality ---------------
% 
% 
% x_tilt = (0:numel(x4_32AziGain)-1)*10^(-4);
% 
% r = RespConfig('Amplitude', 160);
% [y, t] = step(CL_tilt, r);
% y = squeeze(y);
% 
% if isvector(y)
%     y = y(:);
% end
% 
% % Select which output channel to plot (change idxOutput if needed)
% idxOutput = 1;
% tilt_sim = y(:, idxOutput);


% --- Real data ---
x_tilt = (0:numel(x24_83TiltGain)-1)' * 1e-4;
real_data = x24_83TiltGain.Position(:);

Ts = 1e-4;                 % same as real data
t_tilt = 0:Ts:x_tilt(end);   % simulation time vector
u = 160 * ones(size(t_tilt));   % step input

tilt_sim = lsim(CL_tilt, u, t_tilt);

figure
plot(x_tilt,x24_83TiltGain.Position, DisplayName="Reality")
hold on
plot(t_tilt, tilt_sim, 'DisplayName','Simulated')
hold off
grid on
yline(160, DisplayName="Target Angle")
ylabel("Position [degrees]")
xlabel("Time [s]")
title("Tilt P regulator:  simulated vs reality")
 xlim([0 10])
legend show

tilt_min = min(Tilt_sloer.Position);
tilt_max = max(Tilt_sloer.Position);
disp(tilt_min)
disp(tilt_max)