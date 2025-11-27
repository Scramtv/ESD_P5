%clc
%clear all
%close all

sps = 61.44*10^6;   % samples per second


load("data_1.mat")


%% == Rx1
I1_File = real(Rx1_data_TCP_1.IQ);
Q1_File = imag(Rx1_data_TCP_1.IQ);

N_I1_File = length(I1_File);
t_I1_File = (0:(N_I1_File-1)) / sps;
N_Q1_File = length(Q1_File);
t_Q1_File = (0:(N_Q1_File-1)) / sps;


filename = 'Rx1_data_file_1.bin'; 
fid = fopen(filename, 'rb');
if fid == -1
    error('Cannot open file: %s', filename);
end
rawData = fread(fid, 'float32');
fclose(fid);
% Reshape into I/Q pairs
IQ_Bin = reshape(rawData, 2, []);
I1_Bin = IQ_Bin(1, :);
Q1_Bin = IQ_Bin(2, :);


N_I1_Bin = length(I1_Bin);
t_I1_Bin = (0:(N_I1_Bin-1)) / sps;
N_Q1_Bin = length(Q1_Bin);
t_Q1_Bin = (0:(N_Q1_Bin-1)) / sps;


figure
tiledlayout(2,1)
nexttile
plot(t_Q1_File, Q1_File, DisplayName='Q1 file')
hold on
plot(t_I1_File, I1_File, DisplayName='I1 file')
grid on
legend
xlabel("Time [s]")
ylabel("Voltage [V]")
title("IQ samples form Rx1")
hold off

nexttile
plot(t_Q1_Bin, Q1_Bin, DisplayName='Q1 TCP')
hold on
plot(t_I1_Bin, I1_Bin, DisplayName='I1 TCP')
grid on
legend
xlabel("Time [s]")
ylabel("Voltage [V]")
hold off


figure
tiledlayout(2,1)
nexttile
plot(t_Q1_File, Q1_File, DisplayName='Q1 file')
hold on
plot(t_I1_File, I1_File, DisplayName='I1 file')
grid on
legend
xlabel("Time [s]")
ylabel("Voltage [V]")
title("IQ samples form Rx1 zommed")
xlim([0 5*10^-3])
hold off

nexttile
plot(t_Q1_Bin, Q1_Bin, DisplayName='Q1 TCP')
hold on
plot(t_I1_Bin, I1_Bin, DisplayName='I1 TCP')
grid on
legend
xlim([0 5*10^-3])
xlabel("Time [s]")
ylabel("Voltage [V]")
hold off


figure


%% == Rx2

I2_File = real(Rx2_data_TCP_1.IQ);
Q2_File = imag(Rx2_data_TCP_1.IQ);

N_I2_File = length(I2_File);
t_I2_File = (0:(N_I2_File-1)) / sps;
N_Q2_File = length(Q2_File);
t_Q2_File = (0:(N_Q2_File-1)) / sps;


filename = 'Rx2_data_file_1.bin'; 
fid = fopen(filename, 'rb');
if fid == -1
    error('Cannot open file: %s', filename);
end
rawData = fread(fid, 'float32');
fclose(fid);
% Reshape into I/Q pairs
IQ_Bin = reshape(rawData, 2, []);
I2_Bin = IQ_Bin(1, :);
Q2_Bin = IQ_Bin(2, :);


N_I2_Bin = length(I2_Bin);
t_I2_Bin = (0:(N_I2_Bin-1)) / sps;
N_Q2_Bin = length(Q2_Bin);
t_Q2_Bin = (0:(N_Q2_Bin-1)) / sps;


figure
tiledlayout(2,1)
nexttile
plot(t_Q2_File, Q2_File, DisplayName='Q2 File')
hold on
plot(t_I2_File, I2_File, DisplayName='I2 File')
grid on
legend
title("IQ samples form Rx2")
xlabel("Time [s]")
ylabel("Voltage [V]")
hold off

nexttile
plot(t_Q2_Bin, Q2_Bin, DisplayName='Q1 TCP')
hold on
plot(t_I2_Bin, I2_Bin, DisplayName='I1 TCP')
grid on
legend
xlabel("Time [s]")
ylabel("Voltage [V]")
hold off




figure
tiledlayout(2,1)
nexttile
plot(t_Q2_File, Q2_File, DisplayName='Q2 file')
hold on
plot(t_I2_File, I2_File, DisplayName='I2 file')
grid on
legend
xlabel("Time [s]")
ylabel("Voltage [V]")
title("IQ samples form Rx2 zommed")
xlim([0 5*10^-3])
hold off

nexttile
plot(t_Q2_Bin, Q2_Bin, DisplayName='Q2 TCP')
hold on
plot(t_I2_Bin, I2_Bin, DisplayName='I2 TCP')
grid on
legend
xlim([0 5*10^-3])
xlabel("Time [s]")
ylabel("Voltage [V]")
hold off
