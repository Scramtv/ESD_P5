import numpy as np
import timeit

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 78948)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

sample_rate = 61.44e6
N = 900 # sample size
t = np.arange(N)/sample_rate # time vector

for AoA in np.arange(-45, 46, 15):
    print(AoA)
    for i in range(5):
        ### TX SIGNAL
        theta_deg = AoA # reference AoA
        theta_rad = np.deg2rad(theta_deg)
        f = 2e4 # base-band signal frequency
        tx = np.exp(2j * np.pi * f * t) # base-band signal
        d = 1 # distance between elements
        elements = 2 # number of elements in the array
        k = np.arange(elements)

        s = np.exp(2j * np.pi * d * k * np.sin(theta_rad)) # steering vector
        s = s.reshape(-1,1) # row -> column
        tx = tx.reshape(1,-1) # column -> row

        ### RX SIGNAL
        X = s @ tx # received signal matrix
        n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N) # AWGN Noise
        X_n = X + 0.01 * n

        ### TEST CODE
        bf_signal_c = beamforming_das(X_n, 0.5, elements)
        print(bf_signal_c, end=', ')
        if i == 5:
            print()