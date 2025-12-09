clc;
clear;
close all;

% ================================
% Load data
% ================================
load("data.mat");

% Complex IQ from BladeRF
IQ1 = x2442MHz_RX1.Ch1;
IQ2 = x2442MHz_RX2.Ch2;

% Sample rate
Fs = 61.44e6;

% ================================
% Process IQ1 and IQ2
% ================================
processIQ(IQ1, Fs, 'IQ1');
processIQ(IQ2, Fs, 'IQ2');

% ================================
% Local function
% ================================
function processIQ(IQ, Fs, label)

    fprintf('\n===== Processing %s =====\n', label);

    % Ensure column vector
    IQ = IQ(:);

    % Remove DC and trend
    IQ = IQ - mean(IQ);
    IQ = detrend(IQ);

    N = length(IQ);
    fprintf('Number of samples: %d\n', N);
    fprintf('Frequency resolution (Fs/N): %.1f Hz\n', Fs/N);

    if N < 128
        error('%s: Signal too short for frequency analysis.', label);
    end

    % ================================
    % FFT parameters
    % ================================
    nfft = 2^nextpow2(N) * 4;   % zero padding

    % Window
    w  = hann(N);
    IQw = IQ .* w;

    % ================================
    % FFT
    % ================================
    X = fftshift(fft(IQw, nfft));
    P = abs(X) / sum(w);
    magdB = 20*log10(max(P, eps));

    % Frequency axis
    f = (-nfft/2:nfft/2-1) * (Fs/nfft);

    % ================================
    % Plot
    % ================================
    figure;
    plot(f/1e3, magdB, 'LineWidth', 1.2);
    xlabel('Frequency [kHz]');
    ylabel('Magnitude [dB]');
    title(['Complex Baseband FFT - ' label]);
    grid on;
    xlim([-500 500]);
    ylim([-120 0])

    % ================================
    % Peak frequency estimation
    % ================================
    idx = find(f > -500e3 & f < 500e3);
    [~, krel] = max(P(idx));
    k = idx(krel);

    % Quadratic interpolation (log-magnitude)
    if k > 1 && k < length(P)
        L = log([P(k-1), P(k), P(k+1)]);
        delta = 0.5*(L(1)-L(3)) / (L(1)-2*L(2)+L(3));
    else
        delta = 0;
    end

    df = Fs / nfft;
    f_est = f(k) + delta * df;

    fprintf('%s estimated tone frequency: %.1f Hz (%.3f kHz)\n', ...
            label, f_est, f_est/1e3);
end
