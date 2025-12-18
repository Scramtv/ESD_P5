clc
clear all
close all

load("data.mat")

I1 = real(x2442MHz_RX1.Ch1)*0.625;
I1 = reshape(I1, 1, []);
I1 = rms(I1);
I1_N = real(xNoise.Ch1)*0.625;
I1_N = reshape(I1_N, 1, []);
I1_N = rms(I1_N);
SNR_dB = 20*log10(I1/ I1_N);
fprintf('SNR channel I1 %.2f dB\n', SNR_dB)

Q1 = imag(x2442MHz_RX1.Ch1)*0.625;
Q1 = reshape(Q1, 1, []);
Q1 = rms(Q1);
Q1_N = imag(xNoise.Ch1)*0.625;
Q1_N = reshape(Q1_N, 1, []);
Q1_N = rms(Q1_N);
SNR_lin = (Q1 / Q1_N)^2;
SNR_dB = 20*log10(Q1/ Q1_N);
fprintf('SNR channel Q1 %.2f dB\n', SNR_dB)


I2 = real(x2442MHz_RX2.Ch2)*0.625;
I2 = reshape(I2, 1, []);
I2 = rms(I2);
I2_N = real(xNoise.Ch2)*0.625;
I2_N = reshape(I2_N, 1, []);
I2_N = rms(I2_N);
SNR_lin = (I2/ I2_N)^2;
SNR_dB = 20*log10(I2/ I2_N);
fprintf('SNR channel I2 %.2f dB\n', SNR_dB)





Q2 = imag(x2442MHz_RX2.Ch2)*0.625;
Q2 = reshape(Q2, 1, []);
Q2 = rms(Q2);
Q2_N = imag(xNoise.Ch2)*0.625;
Q2_N = reshape(Q2_N, 1, []);
Q2_N = rms(Q2_N);
SNR_lin = (Q2 / Q2_N)^2;
SNR_dB = 20*log10(Q2/ Q2_N);
fprintf('SNR channel Q2 %.2f dB\n', SNR_dB)



