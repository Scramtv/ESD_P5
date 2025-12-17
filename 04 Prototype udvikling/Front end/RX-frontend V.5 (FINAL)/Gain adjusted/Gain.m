clc
clear all
close all

load("data.mat")

% Test af Signal generator direkte ind i BladeRF
% 400 mV pp
% Får 250kHz ind efter downmixing
sps = 40e6;

%% 2442 MHz

I1 = real(x2442MHz_1.Ch1)*0.625;
Q1 = imag(x2442MHz_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;
disp("2442 MHz input")
fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(x2442MHz_2.Ch2)*0.625;
Q2 = imag(x2442MHz_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 1 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
ylim([-650 650])
xlim([0 100])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
ylim([-650 650])
xlim([0 100])
hold off


%% 2500 MHz

I1 = real(x2500MHz_1.Ch1)*0.625;
Q1 = imag(x2500MHz_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

disp("2500 MHz")

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(x2500MHz_2.Ch2)*0.625;
Q2 = imag(x2500MHz_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off


%% Noise

I1 = real(Noise_1.Ch1)*0.625;
Q1 = imag(Noise_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;


disp("Noise")
fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(Noise_2.Ch2)*0.625;
Q2 = imag(Noise_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 1 with no input')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with no input')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

%% Calculate attenuation
I1_2442MHz = real(x2442MHz_1.Ch1)*0.625;
I1_2442MHz = reshape(I1_2442MHz, 1, []);
I1_2442MHz_rms = rms(I1_2442MHz);

I2_2442MHz = real(x2442MHz_2.Ch2)*0.625;
I2_2442MHz = reshape(I2_2442MHz, 1, []);
I2_2442MHz_rms = rms(I2_2442MHz);

I1_N = real(x2500MHz_1.Ch1)*0.625;
I1_N = reshape(I1_N, 1, []);
I1_2500MHz_rms = rms(I1_N);

I2_2500MHz = real(x2500MHz_2.Ch2)*0.625;
I2_2500MHz = reshape(I2_2500MHz, 1, []);
I2_2500MHz_rms = rms(I2_2500MHz);

dB_delta_1 = 20*log10(abs(I1_2442MHz_rms / I1_2500MHz_rms));
dB_delta_2 = 20*log10(abs(I2_2442MHz_rms / I2_2500MHz_rms));

fprintf('Attenuation channel 1 outside pass band %.2f dB\n', dB_delta_1)
fprintf('Attenuation channel 2 outside pass band %.2f dB\n', dB_delta_2)

%% SNR
clc
clear all
close all

load("data.mat")

% Test af Signal generator direkte ind i BladeRF
% 400 mV pp
% Får 250kHz ind efter downmixing
sps = 40e6;

%% 2442 MHz

I1 = real(x2442MHz_1.Ch1)*0.625;
Q1 = imag(x2442MHz_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;
disp("2442 MHz input")
fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(x2442MHz_2.Ch2)*0.625;
Q2 = imag(x2442MHz_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 1 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
ylim([-650 650])
xlim([0 100])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with 2442 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
ylim([-650 650])
xlim([0 100])
hold off


%% 2500 MHz

I1 = real(x2500MHz_1.Ch1)*0.625;
Q1 = imag(x2500MHz_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;

disp("2500 MHz")

fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(x2500MHz_2.Ch2)*0.625;
Q2 = imag(x2500MHz_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with 2500 MHz signal')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off


%% Noise

I1 = real(Noise_1.Ch1)*0.625;
Q1 = imag(Noise_1.Ch1)*0.625;

N_Q1 = length(Q1);
T_Q1 = (0:(N_Q1-1)) / sps;
N_I1 = length(I1);
T_I1 = (0:(N_I1-1)) / sps;


disp("Noise")
fprintf('Maximum amplitude (Volt) Q1: %.2f mV\n', (max(Q1)*10^3));
fprintf('Minimum amplitude (Volt) Q1: %.2f mV\n', (min(Q1)*10^3));
fprintf('Maximum amplitude (Volt) I1: %.2f mV\n', (max(I1)*10^3));
fprintf('Minimum amplitude (Volt) I1: %.2f mV\n', (min(I1)*10^3));


I2 = real(Noise_2.Ch2)*0.625;
Q2 = imag(Noise_2.Ch2)*0.625;

N_Q2 = length(Q2);
T_Q2 = (0:(N_Q2-1)) / sps;
N_I2 = length(I2);
T_I2 = (0:(N_I2-1)) / sps;

fprintf('Maximum amplitude (Volt) Q2: %.2f mV\n', (max(Q2)*10^3));
fprintf('Minimum amplitude (Volt) Q2: %.2f mV\n', (min(Q2)*10^3));
fprintf('Maximum amplitude (Volt) I2: %.2f mV\n', (max(I2)*10^3));
fprintf('Minimum amplitude (Volt) I2: %.2f mV\n', (min(I2)*10^3));

figure
tiledlayout(2,1)
nexttile
plot(T_Q1/(10^-6), Q1/(10^-3), DisplayName="Q1")
hold on 
plot(T_I1/(10^-6), I1/(10^-3), DisplayName="I1")
grid on
legend
title('Channel 1 with no input')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

nexttile
plot(T_Q2/(10^-6), Q2/(10^-3), DisplayName="Q2")
hold on 
plot(T_I2/(10^-6), I2/(10^-3), DisplayName="I2")
grid on
legend
title('Channel 2 with no input')
xlabel('Time [µs]')
ylabel('Amplitude [mV]')
xlim([0 100])
ylim([-25 25])
hold off

%% Calculate attenuation




I1_2442MHz = real(x2442MHz_1.Ch1)*0.625;
I1_2442MHz = reshape(I1_2442MHz, 1, []);
I1_2442MHz_rms = rms(I1_2442MHz);

I2_2442MHz = real(x2442MHz_2.Ch2)*0.625;
I2_2442MHz = reshape(I2_2442MHz, 1, []);
I2_2442MHz_rms = rms(I2_2442MHz);

I1_N = real(x2500MHz_1.Ch1)*0.625;
I1_N = reshape(I1_N, 1, []);
I1_2500MHz_rms = rms(I1_N);

I2_2500MHz = real(x2500MHz_2.Ch2)*0.625;
I2_2500MHz = reshape(I2_2500MHz, 1, []);
I2_2500MHz_rms = rms(I2_2500MHz);

dB_delta_1 = 20*log10(abs(I1_2442MHz_rms / I1_2500MHz_rms));
dB_delta_2 = 20*log10(abs(I2_2442MHz_rms / I2_2500MHz_rms));

fprintf('Attenuation channel 1 outside pass band %.2f dB\n', dB_delta_1)
fprintf('Attenuation channel 2 outside pass band %.2f dB\n', dB_delta_2)

%% SNR


I1_2442MHz = real(x2442MHz_1.Ch1)*0.625;
I1_2442MHz = reshape(I1_2442MHz, 1, []);
I1_2442MHz_rms = rms(I1_2442MHz);


I1_N = real(Noise_1.Ch1)*0.625;
I1_N = reshape(I1_N, 1, []);
I1_N = rms(I1_N);

SNR_lin = (I1_2442MHz_rms / I1_N)^2;
SNR_dB = 20*log10(I1_2442MHz_rms / I1_N);

fprintf('SNR channel 1 %.2f dB\n', SNR_dB)


I2_2442MHz = real(x2442MHz_2.Ch2)*0.625;
I2_2442MHz = reshape(I2_2442MHz, 1, []);
I2_2442MHz_rms = rms(I2_2442MHz);

I2_N = real(Noise_2.Ch2)*0.625;
I2_N = reshape(I2_N, 1, []);
I2_N= rms(I2_N);


SNR_lin = (I2_2442MHz_rms / I2_N)^2;
SNR_dB = 20*log10(I2_2442MHz_rms / I2_N);

fprintf('SNR channel 2 %.2f dB\n', SNR_dB)