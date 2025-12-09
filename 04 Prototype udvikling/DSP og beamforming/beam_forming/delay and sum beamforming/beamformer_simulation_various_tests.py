import timeit
import numpy as np
import matplotlib.pyplot as plt
import csv

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 1000) # Deler -pi/2 til pi/2 op i 1000 segmenter og gemmer i et array
    results = [] # Laver tomt array til resultater
    for thetas in theta_sweep: # For alle de værdier i theta sweep, kører vi
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas)) # Weight vektor tilsvarende "steering vektoren" køres for theta
       y = w.conj().T @ rx # Vi kompleks konjugere for at modarbejde faseforskydningen og transponerer så matricen har den rigtige form
       results.append(np.abs(np.sum(y))) # Vi finder modulus af de to beamformede datapunkter summeret og gemmer dem i arrayet
    return np.rad2deg(theta_sweep[np.argmax(results)]) # Vi kigger efter den theta hvor amplituden er størst og returnere den i grader

sample_rate = 61.44e6
N = 10000 # samples
t = np.arange(N)/sample_rate # time vector

### TX SIGNAL
theta_deg = 0 # Angle of arrival
theta_rad = np.deg2rad(theta_deg)
f = 2e4
tx = np.exp(2j * np.pi * f * t)
d = 0.5# wavelength spacing
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
noise_range = np.arange(0, 5.1, 0.1)
for mult in noise_range:
    print(f"{mult} noise multiplier:")
    for i in range(30):
        noise = np.random.randn(elements, N) + 1j * np.random.randn(elements, N)
        X_noise = X + mult * noise
        result = beamforming_das(X_noise, d, elements)
        print(result)
    print('')

## TIMING TEST - Runs the beamforming algorithm a certain amount of times and returns the avg. elapsed time
# reps = 100
# runtime = timeit.timeit(lambda: beamforming_das(X, d, elements), number=reps)
# print('Avg. runtime ', reps, ' runs: ', runtime/reps)

## SAMPLE ACCURACY TEST CLEAN - Adjusts the sample size to see how the accuracy improves with more samples

## SAMPLE ACCURACY TEST NOISY - Adjusts the sample size to see how the accuracy improves, but now with noise

## SAMPLE RATE TEST - Changes the sample rate and sees how it affects the algorithm

# PLOTS
## Clean RX signal plot

# t_plot = t[0:10000]*1e6
# plt.plot(t_plot, np.asarray(X[0,:]).squeeze().real[0:10000])
# plt.plot(t_plot, np.asarray(X[1,:]).squeeze().real[0:10000])
# plt.plot()
# plt.title('Simulated received baseband signal')
# plt.legend(['Rx 1', 'Rx 2'])
# plt.xlabel('Time (µs)')
# plt.ylabel('Amplitude')
# plt.show()


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


## Polar beamforming plot

# plt.plot(np.linspace(-1*np.pi/2, np.pi/2, 1000), bf_signal)
# plt.xlabel("Theta (Degrees)")
# plt.ylabel("DOA Metric")
# plt.grid()
# plt.show()
