clc
clear all
close all

% %Recivered power
% f_Low = 2400*10^6;
% f_High = 2483.5*10^6;
% f = [f_Low f_High];
% P_T = 10^((17-30)/10);
% G_T = 1;
% G_R = 10^(27/10);
% L = sqrt((8*10^3)^2+(2.5*10^3)^2);
% fprintf('Power transmitted: %.3f mW\n', P_T*10^3);
% 
% Lambda = (3*10^8)./f;
% 
% 
% fprintf('Wavelength: %.3f mm\n', Lambda*10^3);


P_R = 10^((-89.6 -30)/10);
fprintf('Received power: %.3f pW\n', P_R*10^12);
P_R_dBm = 10*log10(P_R)+30;
fprintf('Received power: %.3f dBm\n', P_R_dBm);


%Gain needed
R = 50;
Volt_RMS = sqrt(R*P_R);    
fprintf('Input voltage RMS: %.3f µV\n', Volt_RMS*10^6);

V_Peak = Volt_RMS*sqrt(2);
fprintf('Input voltage peak: %.3f µV\n', V_Peak*10^6);


G_LNA = 0.625./V_Peak;
fprintf('Gain of LNA: %.3f \n', G_LNA);
G_LNA_dB = 20*log10(G_LNA);
fprintf('Gain of LNA in dB: %.3f dB\n', G_LNA_dB);

