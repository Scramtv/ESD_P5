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

###############################################################################################

# Physical constants
c = 3e8

# Bandwidth Carrier frequency
f_hi = 2.4835e9
f_lo = 2.4e9
f_c = f_lo + (f_hi - f_lo)/2

# Tx signal  A*e^(j*2pi*f*t)
A = 1
sample_rate = 61.44e6 # AD9361 data sheet
f = 5e6 # tx signal frequency
td = 10e-6 # time we sample
samples = int(sample_rate * td) # amount of samples we obtain
t = np.linspace(0, td, samples, endpoint=False)

x = A * np.exp(1j * 2 * np.pi * f * t)
noise = 0.1 * (np.random.randn(len(x)) + 1j*np.random.randn(len(x)))
tx = x + noise  # Transmitted signal

# AoA (angle of arrival)
aoa = 2.72  # degrees
aoa_rad = np.deg2rad(aoa)

# Rx setup
wavelength = c / f_c
antennas = 2
dist = wavelength / 2

# Generate steering vector for true AoA
ant_no = np.arange(antennas)
steering_vec = np.exp(-1j * 2 * np.pi * dist * np.sin(aoa_rad) * ant_no / wavelength)

###############################################################################################

# Simulate received signals at each antenna
rx = np.outer(steering_vec, tx)  # antennas, samples
print('RX:')
print(rx)

# Beam forming algo
doa_thetas = np.arange(-90, 90.1, 0.1) # Angular resolution of beamsteering
das_results = []

for theta in doa_thetas:
    theta_rad = np.deg2rad(theta)
    steer = np.exp(-1j * 2 * np.pi * dist * np.sin(theta_rad) * ant_no / wavelength)
    y = np.abs(np.sum(steer.conjugate().T @ rx, axis=0)) # Element wise sum
    das_results.append(np.mean(y))

das_results = np.array(das_results)
das_norm = das_results / np.max(das_results)

# Estimated AoA
direction_of_arrival = doa_thetas[np.argmax(das_results)]
print(f"Estimated DOA: {direction_of_arrival:.2f} degrees")

# Convert to dB
das_db = 20 * np.log10(np.clip(das_norm, 1e-6, None))

# Convert degrees to radians
angles_rad = np.deg2rad(doa_thetas)

# Create polar plot
plt.figure(figsize=(8, 8))
ax = plt.subplot(111, polar=True)

# Plot pattern
ax.plot(angles_rad, das_db, label='Beam Pattern (dB)')
ax.plot(np.pi + angles_rad, das_db, color='gray', alpha=0.4, linestyle='--')

# Polar formatting
ax.set_theta_zero_location('N')   # Boresight
ax.set_theta_direction(-1)        # Clockwise rotation
ax.set_thetamin(-90)
ax.set_thetamax(90)
ax.set_rlabel_position(135)
ax.set_title("Beamforming Polar Response (dB Scale)", va='bottom')
ax.legend(loc='upper right')

# Radial axis in dB
ax.set_rlim(-40, 0)               # Show down to -40 dB
ax.set_rticks([-40, -30, -20, -10, 0])

plt.show()
