import time
import numpy as np

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 78948)
    k = np.arange(no_ele)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * k * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

sample_rate = 61.44e6
N = 10000
t = np.arange(N)/sample_rate
angles = np.concatenate(([-89.9], np.arange(-89, 90, 1), [89.9]))
f = 2e4
d = 0.5
elements = 2
k = np.arange(elements)
tx = np.exp(2j * np.pi * f * t)
print("THETA_REF, THETA_MEAS, DELTA, COMPUTE TIME")
for theta_deg in angles:
    theta_rad = np.deg2rad(theta_deg)
    s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
    s = s.reshape(-1,1)
    tx = tx.reshape(1,-1)
    X = s @ tx

    start = time.perf_counter()
    bf_signal = beamforming_das(X, d, elements)
    stop = time.perf_counter()
    print(f"{theta_deg}, {bf_signal:.6f}, {np.abs(theta_deg-bf_signal):.6f}, {stop-start:.4f}")