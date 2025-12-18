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
    snr_lin = 10 ** (SNR / 10)
    a_noise_rms = 1 / np.sqrt(snr_lin)
    a_noise = a_noise_rms * np.sqrt(2)
    return a_noise

sample_rate = 61.44e6
N = 1
t = np.arange(N)/sample_rate

### TX SIGNAL
theta_deg = 38 # Angle of arrival
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


### TEST CODE
## FUNCTIONALITY TEST
for snr in np.arange(-50, 110, 10):
    X_n = X + snr_to_peak_amplitude(snr)* n
    bf_signal_c = beamforming_das(X_n, d, elements)
    print(bf_signal_c, end=', ')

### TEST CODE
#reps = 10
#runtime = timeit.timeit(lambda: beamforming_das(X_n, d, elements), number=reps)
#print("REPETITIONS, TOTAL RUNTIME, AVG RUNTIME")
#print(f'{reps}, {runtime}, {runtime / reps}')

### PLOT

    t_plot = t[0:10000]*1e6
    plt.plot(t_plot, np.asarray(X_n[0,:]).squeeze().real[0:10000])
    plt.plot(t_plot, np.asarray(X_n[1,:]).squeeze().real[0:10000])
    plt.plot(t_plot, np.asarray(X[0,:]).squeeze().real[0:10000])
    plt.plot(t_plot, np.asarray(X[1,:]).squeeze().real[0:10000])
    plt.plot()
    plt.title('Simulated base-band signals at 20 degree AoA')
    plt.legend([f'Rx 1 (SNR = {snr})', f'Rx 2 (SNR = {snr})', 'Rx 1 (clean)', 'Rx 2 (clean)'], loc='lower right')
    plt.xlabel('Time (µs)')
    plt.ylabel('Amplitude')
    plt.savefig(f'plot_simulated_signal_snr_{snr}', dpi=300)
    plt.show()
