import numpy as np

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 78948)
    k = np.arange(no_ele)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * k * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

def snr_to_peak_amplitude(SNR):
    snr_lin = 10 ** (SNR / 20)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

sample_rate = 61.44e6
sample_sizes = [2000, 1000]
f = 2e4
d = 0.5
elements = 2
k = np.arange(elements)
theta_deg = 0
theta_rad = np.deg2rad(theta_deg)

print("N, THETA_REF, THETA_MEAS, DELTA, COMPUTE TIME")
for sample_size in sample_sizes:
    N = sample_size
    t = np.arange(N) / sample_rate
    tx = np.exp(2j * np.pi * f * t)
    s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
    s = s.reshape(-1, 1)
    tx = tx.reshape(1, -1)
    X = s @ tx
    for i in range(50):
        n = np.random.randn(elements, N) + 1j * np.random.randn(elements, N)
        X_n = X + snr_to_peak_amplitude(5) * n
        bf_signal = beamforming_das(X_n, d, elements)
        print(f"{N}, {theta_deg}, {bf_signal:.6f}, {np.abs(theta_deg-bf_signal):.6f}")