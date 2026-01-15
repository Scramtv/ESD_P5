
clc
clear
close all

% Center frequency in the 2.4 GHz ISM band% Center frequency in the 2.4 GHz ISM band
f_Low  = 2400e6;
f_High = 2483.5e6;
f      = (f_Low + f_High)/2;

% Transmit power: 17 dBm -> Watts
P_T_dBm = 17;
P_T     = 10^((P_T_dBm - 30)/10);   % W

% Antenna gains
G_T_dBi = 0;                        % 0 dBi => linear 1
G_R_dBi = 9.28;
G_T     = 10^(G_T_dBi/10);          % linear
G_R     = 10^(G_R_dBi/10);          % linear

% Wavelength
c       = 3e8;
lambda  = c / f;

% Target received power: -89.6 dBm -> Watts
P_R_dBm = -89.6;
P_R     = 10^((P_R_dBm - 30)/10);   % W

% Friis rearranged to solve for distance D
D = (lambda / (4*pi)) * sqrt( (G_T * G_R * P_T) / P_R );


fprintf('Length to get a input of 5 db SNR: %.3f m\n', D);


f_Low  = 2400e6;
f_High = 2483.5e6;
f      = (f_Low + f_High)/2;
c       = 3e8;
lambda  = c / f;

P_t = 10^((17-30)/10);
P_r = 10^((-89.6-30)/10);

D = 8382;

G = (16*P_r*pi^2*D^2)/(lambda^2*P_t);
fprintf('Gain: %.3f  \n', G);

