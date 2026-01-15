import numpy as np
import timeit
import matplotlib.pyplot as plt

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 78948)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

def snr_to_peak_amplitude(SNR):
    snr_lin = 10 ** (SNR / 20)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

sample_rate = 61.44e6
N = 900
t = np.arange(N)/sample_rate

### TX SIGNAL
theta_deg = 0 # Angle of arrival
theta_rad = np.deg2rad(theta_deg)
f = 2e4
tx = np.exp(2j * np.pi * f * t)
d = 0.5 # wavelength spacing
elements = 2
k = np.arange(elements)

s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
s = s.reshape(-1,1) # make s a column vector
tx = tx.reshape(1,-1) # make tx a row vector

### RX SIGNAL
X = s @ tx
n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N) #Noise
X_n = X + snr_to_peak_amplitude(20)* n

### TEST CODE
reps = 100
runtime = timeit.timeit(lambda: beamforming_das(X_n, d, elements), number=reps)
print("REPETITIONS, TOTAL RUNTIME, AVG RUNTIME")
print(f'{reps}, {runtime}, {runtime / reps}')
