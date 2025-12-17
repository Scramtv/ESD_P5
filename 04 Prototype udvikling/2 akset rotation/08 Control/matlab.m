%% bodeplot
clc
close all;
clear all;

s=tf('s');
sys_azi=(17.63*10^3)/(s*((7.73*s+3.97)*(724.31+1.88*s)+17.63*810.90));
sys_tilt=(404.91* 10^3)/(s*((15.44*s + 5.16)*(6.73* 10^3 + 3.87*s) + 404.91*285.57));

figure;
bode(sys_azi, sys_tilt)
title('Open loop bodeplot');
legend('Azimuth', 'Tilt');
grid("on");

%% zoomed bodeplot

h=bodeplot(sys_azi, sys_tilt);

%Zoom
axesHandles = findall(h,'type','axes');

magAx = axesHandles(1);
phaseAx = axesHandles(2); 

ylim(magAx, [-40, 10]);
xlim(magAx, [1 15]);
xlim(phaseAx, [1 15]);
ylim(phaseAx, [-180,-90]);
title("Open loop zoomed")
legend('Azimuth', 'Tilt');
grid("on");



%% P-controller
d_azi=24.83;
d_tilt=4.32;

CL_azi=(d_azi*sys_azi)/(1+d_azi*sys_azi);
CL_tilt=(d_tilt*sys_tilt)/(1+d_tilt*sys_tilt);

d_azi=1;
d_tilt=1;
azi=(d_azi*sys_azi)/(1+d_azi*sys_azi);
tilt=(d_tilt*sys_tilt)/(1+d_tilt*sys_tilt);


figure;
step(CL_azi, RespConfig('StepAmplitude', 120));
hold on
step(azi, RespConfig('StepAmplitude', 120));
t_limits = get(gca, 'XLim'); 
plot(t_limits, [120 120], 'Color', [0.5 0.5 0.5])
title('Closed loop azimuth step response');
legend('P = 24.83', 'P = 1', 'Target');
grid("on")
hold off



figure;
step(CL_tilt, RespConfig('StepAmplitude', 45));
hold on
step(tilt, RespConfig('StepAmplitude', 45));
t_limits = get(gca, 'XLim'); 
plot(t_limits, [45 45], 'Color', [0.5 0.5 0.5])
title('Closed loop tilt step response');
legend('P = 4.32','P = 1', 'Target');
grid("on")
hold off




%% time until accurate within specs - Kindly sponsered by ChatGPT

% --- Tolerancer (grader) ---
tol_azi_deg  = 9.17e-3;     % tolerance for azimuth i grader
tol_tilt_deg = 4.58e-3;      % tolerance for tilt i grader

Amp = 90;                  % step amplitude (grader)

% ============================================================
% Helperfunktion (simpel & sikker i MATLAB)
% ============================================================
function Ts = settling_time(y, t, tol_deg)
    
    y_end = y(end);
    within_tol = abs(y - y_end) <= tol_deg;

    % suffix_all(i) = true hvis alle samples fra i..end ligger indenfor tol
    suffix_all = flipud(cummin(flipud(within_tol)));

    k = find(suffix_all, 1, 'first');
    if isempty(k)
        Ts = NaN;
    else
        Ts = t(k);
    end
end
% ============================================================
% --- AZIMUTH ---
% ============================================================
[y_azi, t_azi] = step(Amp * CL_azi);
Ts_azi = settling_time(y_azi, t_azi, tol_azi_deg);

% ============================================================
% --- TILT ---
% ============================================================
[y_tilt, t_tilt] = step(Amp * CL_tilt);
Ts_tilt = settling_time(y_tilt, t_tilt, tol_tilt_deg);

% ============================================================
% --- Resultater ---
% ============================================================
disp(['Settling time (azi)  to ±' num2str(tol_azi_deg)  ' deg: ' num2str(Ts_azi)  ' s']);
disp(['Settling time (tilt) to ±' num2str(tol_tilt_deg) ' deg: ' num2str(Ts_tilt) ' s']);

% ============================================================
% --- Plot (med korrekte tolerancer) ---
% ============================================================
figure;

subplot(2,1,1)
plot(t_azi, y_azi); hold on
yline(y_azi(end) + tol_azi_deg,'--'); 
yline(y_azi(end) - tol_azi_deg,'--');
xline(Ts_azi,'r--');
title('Azimuth response (deg)'); grid on
legend('y_{azi}','upper tol','lower tol','Ts','Location','best')

subplot(2,1,2)
plot(t_tilt, y_tilt); hold on
yline(y_tilt(end) + tol_tilt_deg,'--'); 
yline(y_tilt(end) - tol_tilt_deg,'--');
xline(Ts_tilt,'r--');
title('Tilt response (deg)'); grid on
legend('y_{tilt}','upper tol','lower tol','Ts','Location','best')
