def snr_to_peak_amplitude(SNR):
    snr_lin = 10 ** (SNR / 20)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N)
X_n = X + snr_to_peak_amplitude(snr)* n