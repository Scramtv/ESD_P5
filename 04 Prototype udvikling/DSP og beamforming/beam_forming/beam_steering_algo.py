import numpy as np
import matplotlib.pyplot as plt

# Strongest frequency function
def find_freq(data, f_sample):
    fft_data = np.fft.fft(data)
    frequencies = np.fft.fftfreq(len(data), d=1 / f_sample)
    magnitude = np.abs(fft_data)
    peak_index = np.argmax(magnitude[:len(magnitude)//2])  # Ignore negative frequencies
    dominant_frequency = frequencies[peak_index]
    return dominant_frequency

# Physical constants
c = 3e8

# Bandwidth Carrier frequency
f_hi = 2.4835e9
f_lo = 2.4e9
f_c = f_lo + (f_hi - f_lo)/2
print(f_c)

# Tx signal  A*e^(j*2pi*f*t)
A = 1
sample_rate = 61.44e6
f = 5e6
td = 10e-6
samples = int(sample_rate * td)
t = np.linspace(0, td, samples, endpoint=False)

x = A * np.exp(1j * 2 * np.pi * f * t)
noise = 0.1 * (np.random.randn(len(x)) + 1j*np.random.randn(len(x)))
tx = x + noise  # Transmitted signal

# AoA (angle of arrival)
aoa = 0  # degrees
aoa_rad = np.deg2rad(aoa)

# Rx setup
wavelength = c / f_c
antennas = 2
dist = wavelength / 2

# Generate steering vector for true AoA
ant_no = np.arange(antennas)
steering_vec = np.exp(-1j * 2 * np.pi * dist * np.sin(aoa_rad) * ant_no / wavelength)

# Simulate received signals (each antenna gets delayed version)
rx = np.outer(steering_vec, tx)  # shape: (antennas, samples)

# Beam forming algo
doa_thetas = np.arange(-90, 90.1, 0.1)
bf_results = []

for theta in doa_thetas:
    theta_rad = np.deg2rad(theta)
    steer = np.exp(-1j * 2 * np.pi * dist * np.sin(theta_rad) * ant_no / wavelength)
    # Classic delay-sum beamformer (matched filter)
    y = np.abs(np.sum(steer.conjugate().T @ rx, axis=0))
    bf_results.append(np.mean(y))

bf_results = np.array(bf_results)
bf_norm = bf_results / np.max(bf_results)

# Estimated AoA
direction_of_arrival = doa_thetas[np.argmax(bf_results)]
print(f"Estimated DOA: {direction_of_arrival:.2f} degrees")



# Convert to dB scale (avoid log(0) issues)
bf_db = 20 * np.log10(np.clip(bf_norm, 1e-6, None))

# Convert degrees to radians
angles_rad = np.deg2rad(doa_thetas)

# Create polar plot
plt.figure(figsize=(8, 8))
ax = plt.subplot(111, polar=True)

# Plot pattern (optionally mirrored for full 360°)
ax.plot(angles_rad, bf_db, label='Beam Pattern (dB)')
ax.plot(np.pi + angles_rad, bf_db, color='gray', alpha=0.4, linestyle='--')  # mirror

# Polar formatting
ax.set_theta_zero_location('N')   # 0° at top (boresight)
ax.set_theta_direction(-1)        # Clockwise rotation
ax.set_thetamin(-90)
ax.set_thetamax(90)
ax.set_rlabel_position(135)
ax.set_title("Beamforming Polar Response (dB Scale)", va='bottom')
ax.legend(loc='upper right')

# Radial axis (dB scale)
ax.set_rlim(-40, 0)               # Show down to -40 dB
ax.set_rticks([-40, -30, -20, -10, 0])

plt.show()
