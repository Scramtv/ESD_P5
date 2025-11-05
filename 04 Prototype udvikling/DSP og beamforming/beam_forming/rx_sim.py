import numpy as np
import matplotlib.pyplot as plt


# BladeRF parameters
fs = 61.44e6          # Sampling frequency (61.44 MS/s)
duration = 10e-6      # 10 microseconds of signal
amplitude = 1.0       # Normalized signal amplitude

# Bluetooth / RF simulation parameters
f_offset = 200e3      # 200 kHz frequency offset after downconversion (optional)
phase_offset = np.deg2rad(30)  # arbitrary initial phase (e.g., 30 degrees)
snr_db = 30           # optional: add noise at 30 dB SNR

# Derived quantities
t = np.arange(0, duration, 1/fs)

# Complex baseband signal (as would be seen after direct downconversion)
signal_bb = amplitude * np.exp(1j * (2 * np.pi * f_offset * t + phase_offset))

# Optionally add complex AWGN noise
snr_linear = 10**(snr_db / 10)
noise_power = amplitude**2 / (2 * snr_linear)
noise = np.sqrt(noise_power) * (np.random.randn(len(t)) + 1j*np.random.randn(len(t)))
signal_noisy = signal_bb + noise

# Plot I/Q components (short segment)
plt.figure(figsize=(10, 4))
plt.plot(t[:2000]*1e6, np.real(signal_noisy[:2000]), label="I (In-phase)")
plt.plot(t[:2000]*1e6, np.imag(signal_noisy[:2000]), label="Q (Quadrature)", alpha=0.7)
plt.title("BladeRF Baseband Bluetooth-like Signal (fs = 61.44 MS/s)")
plt.xlabel("Time (µs)")
plt.ylabel("Amplitude")
plt.legend()
plt.grid(True)
plt.show()

# Plot I/Q constellation
plt.figure(figsize=(5,5))
plt.plot(np.real(signal_noisy), np.imag(signal_noisy), '.', alpha=0.3)
plt.title("Baseband Constellation (Pure Tone + Noise)")
plt.xlabel("I")
plt.ylabel("Q")
plt.axis('equal')
plt.grid(True)
plt.show()

'''
# Parameters
fs = 10e6          # Sample frequency
f_offset = 0      # Frequency offset (currently ideal eg. no LO mismatch)
duration = 1e-12    # 1 ms signal
amplitude = 1.0    # Signal amplitude

# Time vector
t = np.arange(0, duration, 1/fs)

# Generate complex baseband Bluetooth-like signal
# (Represents a tone that would have been at 2.44 GHz before downconversion)
signal_bb = amplitude * np.exp(1j * 2 * np.pi * f_offset * t)

# Extract I and Q for plotting
I = np.real(signal_bb)
Q = np.imag(signal_bb)

# Plot I/Q components
plt.figure(figsize=(10, 4))
plt.plot(t[:2000], I[:2000], label='In-phase (I)')
plt.plot(t[:2000], Q[:2000], label='Quadrature (Q)', alpha=0.7)
plt.title("Bluetooth Complex Signal at baseband")
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.legend()
plt.grid(True)
plt.show()
'''