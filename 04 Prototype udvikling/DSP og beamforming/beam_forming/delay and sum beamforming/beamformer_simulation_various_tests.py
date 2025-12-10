import timeit
import numpy as np
import matplotlib.pyplot as plt
import csv

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 1000)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

sample_rate = 61.44e6
N = 10000
t = np.arange(N)/sample_rate

### TX SIGNAL
theta_deg = 45 # Angle of arrival
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
X_n = X + 0.1 * n

### TEST CODE
## FUNCTIONALITY TEST
# bf_signal = beamforming_das(X_n, d, elements)
# print(bf_signal)

## NOISE FLOOR TEST - Generates AWGN and adds it to the received signal with a range of different amplitudes
# noise_range = np.arange(0, 5.1, 0.1)
# for mult in noise_range:
#     print(f"{mult} noise multiplier:")
#     for i in range(30):
#         noise = np.random.randn(elements, N) + 1j * np.random.randn(elements, N)
#         X_noise = X + mult * noise
#         result = beamforming_das(X_noise, d, elements)
#         print(result)
#     print('')

## TIMING TEST - Runs the beamforming algorithm a certain amount of times and returns the avg. elapsed time
# reps = 100
# runtime = timeit.timeit(lambda: beamforming_das(X, d, elements), number=reps)
# print('Avg. runtime ', reps, ' runs: ', runtime/reps)

# PLOTS
## Clean RX signal plot
t_plot = t[0:10000]*1e6
plt.plot(t_plot, np.asarray(X_n[0,:]).squeeze().real[0:10000])
plt.plot(t_plot, np.asarray(X_n[1,:]).squeeze().real[0:10000])
plt.plot(t_plot, np.asarray(X[0,:]).squeeze().real[0:10000])
plt.plot(t_plot, np.asarray(X[1,:]).squeeze().real[0:10000])
plt.plot()
plt.title('Simulated received baseband signals at 45 degree AoA')
plt.legend(['Rx 1 (noisy)', 'Rx 2 (noisy)', 'Rx 1 (clean)', 'Rx 2 (clean)'])
plt.xlabel('Time (µs)')
plt.ylabel('Amplitude')
plt.savefig('simulated_signals_45_deg.png', dpi=300)
plt.show()


## Noisy RX signal plot
# t_plot = t[0:10000]*1e6
# plt.plot(t_plot, np.asarray(X_noise[0,:]).squeeze().real[0:10000])
# plt.plot(t_plot, np.asarray(X_noise[1,:]).squeeze().real[0:10000])
# plt.plot(t_plot, np.asarray(X_noise[0,:]).squeeze().imag[0:10000])
# plt.plot(t_plot, np.asarray(X_noise[1,:]).squeeze().imag[0:10000])
# plt.plot()
# plt.title('Simulated received baseband signal with noise')
# plt.legend(['I', 'Q'])
# plt.xlabel('Time (µs)')
# plt.ylabel('Amplitude')
# plt.savefig('plot_dirty_signal_IQ_2.png', dpi=300)
# plt.show()