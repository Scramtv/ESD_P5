clc;
clear;
close all;

load("data.mat");

IQ1 = x2442MHz_1.Ch1*0.625;
IQ2 = x2442MHz_2.Ch2*0.625;

% Sample rate
Fs = 40e6;

% ================================
% Process IQ1 and IQ2
% ================================
processIQ(IQ1, Fs, 'Channel 1');
processIQ(IQ2, Fs, 'Channel 2');

% ================================
% Local function
% ===============================


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

    % FFT parameters
    nfft = 2^nextpow2(N) * 4;   % zero padding

    % Window
    w  = hann(N);
    IQw = IQ .* w;

    % FFT
    X = fftshift(fft(IQw, nfft));
    P = abs(X) / sum(w);
    magdB = 20*log10(max(P, eps));

    % Frequency axis (Hz)
    f = (-nfft/2:nfft/2-1) * (Fs/nfft);

    % Plot (convert to kHz)
    figure;
    plot(f/1e3, magdB, 'LineWidth', 1.2); hold on;
    xlabel('Frequency [kHz]');
    ylabel('Magnitude [dB]');
    title(['Complex Baseband FFT - ' label]);
    grid on;
    xlim([-500 500]);
    ylim([-120 0]);

    % --- Add vertical lines at the requested frequencies (Hz) ---
    freqs_hz = [-247750, 0, 247750];
    freqs_khz = freqs_hz / 1e3;
    % Use xline for clarity (R2018b+). If unavailable, use plot().
    try
        xline(freqs_khz(1), '--r', 'LineWidth', 1.2);
        xline(freqs_khz(2), ':k',  'LineWidth', 1.2);
        xline(freqs_khz(3), '--r', 'LineWidth', 1.2);
    catch
        % Fallback for older MATLAB: draw using plot
        yl = ylim;
        plot([freqs_khz(1) freqs_khz(1)], yl, '--r', 'LineWidth', 1.2);
        plot([freqs_khz(2) freqs_khz(2)], yl, ':k',  'LineWidth', 1.2);
        plot([freqs_khz(3) freqs_khz(3)], yl, '--r', 'LineWidth', 1.2);
    end

   
    hold off;

    % Peak frequency estimation (unchanged)
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
