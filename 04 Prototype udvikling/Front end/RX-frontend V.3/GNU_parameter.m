clc
clear all
close all



f_high = 2483.5*10^6;
f_low = 2400*10^6;
f_band = [f_high, f_low];
fprintf('Frequency band: %.3f MHz\n', f_band*10^-6)

f_cent = (f_high-f_low)/2 + f_low;
fprintf('Center Frequency: %.3f MHz\n', f_cent*10^-6)

BW = 56*10^6;

f_lower_limit = f_cent - BW/2;
fprintf('Lower Limit Frequency: %.3f MHz\n', f_lower_limit*10^-6);
f_upper_limit = f_cent + BW/2;
fprintf('Upper Limit Frequency: %.3f MHz\n', f_upper_limit*10^-6);
