clc
close all;
clear all;

s=tf('s');

sys_org=0.01763000000/(s*((0.007730000000*s + 0.003970000000)*(0.7243100000 + 0.001880000000*s) + 0.01429616700));
sys_new=0.01763000000/(s*((0.00863512331829492*s + 0.003970000000)*(0.7243100000 + 0.001880000000*s) + 0.01429616700));


sys_org_cl=sys_org/(1+sys_org);
sys_new_cl=sys_new/(1+sys_new);


figure;
bode(sys_org, sys_new)
title('Open loop bodeplot Comparison');
legend('Org', 'new');

figure;
step(sys_org_cl, sys_new_cl)
title('Closed-Loop Step Response Comparison');
legend('Org', 'New');
