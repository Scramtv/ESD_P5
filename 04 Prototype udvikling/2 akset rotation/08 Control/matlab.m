%% P controller til azi
clc
close all;
clear all;

s=tf('s');

sys=0.32736/(s*((s + 0.225409715443564)*(0.0019*s + 0.7242) + 3.574790842));


%P=167.8804018
%Det ses ret tydeligt på bodeplottet at en PI vil gøre systemet ustabilt
D=80.35261222; %D = controller I.e. P controller
sys_P = sys*D;

D=(s + 28.5)/(s + 2850);
sys_lead = sys*D;

sys_cl=sys/(1+sys);
sys_P_cl=sys_P/(1+sys_P);
sys_lead_cl=sys_lead/(1+sys_lead);



figure;
bode(sys, sys_P, sys_lead)
title('Open loop bodeplot Comparison azi');
legend('Open-Loop (G)', 'P-controller Open-Loop (DG)', 'lead');

figure;
step(sys_cl, sys_P_cl, sys_lead_cl)
title('Closed-Loop Step Response Comparison azi');
legend('Closed-Loop (G / (1+G))', 'P-controller Closed-Loop (DG / (1+DG))', 'lead');


%% P controller til tilt
clc
close all;
clear all;

s=tf('s');

sys=0.4056/(s*((0.0154756329092856*s + 0.0138947737227036)*(0.0916*s + 6.73) + 1.1486592));


%P=38.01893963
%Det ses ret tydeligt på bodeplottet at en PI vil gøre systemet ustabilt
D=38.01893963; %D = controller I.e. P controller
sys_P = sys*D;

sys_cl=sys/(1+sys);
sys_P_cl=sys_P/(1+sys_P);


figure;
bode(sys, sys_P)
title('Open loop bodeplot Comparison tilt');
legend('Open-Loop (G)', 'P-controller Open-Loop (DG)');

figure;
step(sys_cl, sys_P_cl)
title('Closed-Loop Step Response Comparison tilt');
legend('Closed-Loop (G / (1+G))', 'P-controller Closed-Loop (DG / (1+DG))');


