import numpy as np
import matplotlib.pyplot as plt

#strongest frequency function
def find_freq(data, f_sample):
    fft_data = np.fft.fft(data)
    frequencies = np.fft.fftfreq(len(data), d=1 /f_sample)
    magnitude = np.abs(fft_data)
    # Find the index of the peak frequency
    peak_index = np.argmax(magnitude[:len(magnitude) // 2])  # Ignore negative frequencies
    dominant_frequency = frequencies[peak_index]
    return dominant_frequency

'''
#Beamforming delay sum
def beamforming_ds(data, thetas):
    rx_0 = data[0] # reference signal
    rx_1 = data[1] # phase shifted signal
    peak_sig = []

    for phase_inc in thetas:
        phase_inc_rad = np.deg2rad(phase_inc)
        delay_rx_1 = rx_1 * np.exp(1j*phase_inc_rad) # Add phase delay step to
        delay_sig_amplitude = np.abs(np.fft.fft(rx_0+delay_rx_1))
        peak_sig.append(delay_sig_amplitude)
    return thetas, peak_sig
'''

# Physical constants
c = 3e8

# Bandwidth Carrier frequency
f_hi = 2.4835e9
f_lo = 2.4e9
f_c = f_lo+(f_hi-f_lo)/2

# Tx signal  A*e^(j*2pi*f*t)
A = 1
sample_rate = 61.44e6
f = 5e6
td = 10e-6
samples = sample_rate * td
t = np.linspace(0, td, int(samples))
x = A*np.exp(1j*2*np.pi*f*t)
noise = 0.1*np.random.randn(len(x)) + 0.1*np.random.normal(len(x))
tx = x # Transmitted signal
aoa = 20 # planewave angle of arrival in relation to boresight
aoa_rad = np.deg2rad(aoa)

'''
# Tx plot
plt.plot(t, np.real(tx))
plt.xlabel('time (microseconds)')
plt.ylabel('amplitude')
plt.show()
'''

# Rx
wavelength = c/f_c
antennas = 2
dist = wavelength/2

# Generate steering vector
ant_no = np.arange(antennas)
s = A * np.exp(-1j * 2 * np.pi * dist * np.sin(aoa_rad) * ant_no)
s = s.T
s = np.shape(s)
rx = tx * s
rx = rx.reshape(-1, 1)


# Beamforming
bf_results = []
doa_thetas = np.arange(-90, 90, 0.1) # Sweep 180 deg with a resolution of .1 deg
for theta in doa_thetas:
    s = A * np.exp(-1j * 2 * np.pi * dist * np.sin(theta) * ant_no)
    delay_sum = s.conjugate().T*rx
    bf_results.append(delay_sum)

bf_results = np.abs(bf_results)
direction_of_arrival = np.argmax(bf_results)
print(direction_of_arrival)