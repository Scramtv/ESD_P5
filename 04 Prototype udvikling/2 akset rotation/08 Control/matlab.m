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


%% P-controller
d_azi=24.83;
d_tilt=4.32;

CL_azi=(d_azi*sys_azi)/(1+d_azi*sys_azi);
CL_tilt=(d_tilt*sys_tilt)/(1+d_tilt*sys_tilt);

figure;
step(CL_azi, CL_tilt);
title('Closed loop step response');
legend('Azimuth', 'Tilt');

