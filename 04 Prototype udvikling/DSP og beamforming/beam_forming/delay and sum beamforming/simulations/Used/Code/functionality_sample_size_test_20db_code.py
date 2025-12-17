import numpy as np
import time

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1 * np.pi / 2, np.pi / 2,
                              78948)  # Deler -pi/2 til pi/2 op i 1000 segmenter og gemmer i et array
    results = []  # Laver tomt array til resultater
    for thetas in theta_sweep:  # For alle de værdier i theta sweep, kører vi
        w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(
            thetas))  # Weight vektor tilsvarende "steering vektoren" køres for theta
        y = w.conj().T @ rx  # Vi kompleks konjugere for at modarbejde faseforskydningen og transponerer så matricen har den rigtige form
        results.append(
            np.abs(np.sum(y)))  # Vi finder modulus af de to beamformede datapunkter summeret og gemmer dem i arrayet
    return np.rad2deg(theta_sweep[np.argmax(
        results)])  # Vi kigger efter den theta hvor amplituden er størst og returnere den i grader

def snr_to_peak_amplitude(SNR):
    snr_lin = 10 ** (SNR / 10)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

sample_space = np.concatenate([np.arange(1, 10) * 10 ** k for k in range(5)])
sample_space = np.append(sample_space, 100000)
sample_rate = 61.44e6
f = 2e4
d = 0.5  # half wavelength spacing
theta_deg = 0  # Angle of arrival
theta_rad = np.deg2rad(theta_deg)
elements = 2
k = np.arange(elements)

print('---20 dB SNR Test Start---')
print('SAMPLE SIZE, ELAPSED TIME (s), AOA')
for sample_size in sample_space:
    N = sample_size  # samples
    print(N)
    for i in range(31):
        t = np.arange(N) / sample_rate  # time vector
        tx = np.exp(2j * np.pi * f * t)
        s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
        s = s.reshape(-1, 1)  # make s a column vector
        tx = tx.reshape(1, -1)  # make tx a row vector
        X = s @ tx
        n = np.random.randn(elements, N) + 1j * np.random.randn(elements, N)  # Noise
        X_n = X + snr_to_peak_amplitude(20) * n
        start = time.perf_counter()
        results = beamforming_das(X_n, d, elements)
        stop = time.perf_counter()
        print(f'{results:.6f}', end=', ')
    print('')