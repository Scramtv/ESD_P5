import time
import numpy as np

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 78948)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

def snr_to_peak_amplitude(SNR):
    snr_lin = 10 ** (SNR / 10)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

sample_rate = 61.44e6
N = 900
t = np.arange(N)/sample_rate

### TX SIGNAL

angles = np.arange(-90, 91, 1)
print("SNR, ANGLE, BEAMFORMING OUTPUT AOA, DELTA, COMPUTE TIME")
for snr in np.arange(-10, 50, 10):
    for angle in angles:
        theta_deg = 0 # Angle of arrival
        theta_rad = np.deg2rad(angle)
        f = 2e4
        tx = np.exp(2j * np.pi * f * t)
        d = 0.5
        elements = 2
        k = np.arange(elements)

        s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
        s = s.reshape(-1,1)
        tx = tx.reshape(1,-1)

        ### RX SIGNAL
        X = s @ tx
        n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N)
        X_n = X + snr_to_peak_amplitude(snr) * n

        ### TEST CODE
        ## FUNCTIONALITY TEST
        start = time.perf_counter()
        bf_signal = beamforming_das(X_n, d, elements)
        stop = time.perf_counter()
        print(f"{snr}, {angle}, {bf_signal:.6f}, {np.abs(angle-bf_signal):.6f}, {stop-start:.4f}")

