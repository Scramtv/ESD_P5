clc
clear all
close all

High = 2483.5e6;
Low = 2400e6;
MaxBP = 56e6;

fprintf('Frequency range from %.5f MHz to %.5f MHz\n', Low/1e6, High/1e6);

BandRange = High-Low;
fprintf('BandRange: %.5f MHz\n', BandRange/1e6);

numChannels = ceil(BandRange / MaxBP);
fprintf('Number of channels needed: %d\n', numChannels);

channelBandwidth = BandRange / numChannels;
fprintf('Channel bandwidth: %.5f MHz\n', channelBandwidth/1e6);

Channel1HighLimit = Low + channelBandwidth;
fprintf('Channel 1 range: %.5f MHz to %.5f MHz\n', Low/1e6, Channel1HighLimit/1e6);
Channel2HighLimit = Channel1HighLimit+ channelBandwidth;
fprintf('Channel 2 range: %.5f MHz to %.5f MHz\n', Channel1HighLimit/1e6, Channel2HighLimit/1e6);


Channel1CF = channelBandwidth/2 + Low;
fprintf('Channel 1 center frequency: %.5f MHz\n', Channel1CF/1e6);
Channel2CF = channelBandwidth/2 + Channel1HighLimit;
fprintf('Channel 2 center frequency: %.5f MHz\n', Channel2CF/1e6);