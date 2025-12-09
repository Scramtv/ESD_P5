import time
import numpy as np

sample_rate = 61.44e6
N = 10000 # samples
t = np.arange(N)/sample_rate # time vector

### TX SIGNAL
theta_deg = 0 # Angle of arrival
theta_rad = np.deg2rad(theta_deg)
f = 2e4
tx = np.exp(2j * np.pi * f * t)
d = 0.5 # wavelength spacing
elements = 2
k = np.arange(elements)

s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
s = s.reshape(-1,1)
tx = tx.reshape(1,-1)

### RX SIGNAL
X = s @ tx
n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N) #Noiseh
X_n = X + 0.0 * n

### TEST CODE
## FUNCTIONALITY TEST
print("SUBDIVISIONS, ELAPSED TIME (s), AOA")
for i in range(1,16):
    angle_subdiv = 2**i
    start = time.perf_counter()
    theta_sweep = np.linspace(-1 * np.pi / 2, np.pi / 2, angle_subdiv)
    results = []
    for thetas in theta_sweep:
        w = np.exp(2j * np.pi * d * k * np.sin(thetas))
        y = w.conj().T @ X_n
        results.append(np.abs(np.sum(y)))
    stop = time.perf_counter()
    print(f"{angle_subdiv}, {stop-start:.6f}, {np.rad2deg(theta_sweep[np.argmax(results)])}")


### PLOTS
## Polar beamforming plot

# fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
# ax.plot(np.linspace(-1*np.pi/2, np.pi/2, 1000), results)
# ax.set_theta_zero_location('N')
# ax.set_theta_direction(-1)
# ax.set_rlabel_position(55)  # Move grid labels away from other labels
# ax.set_thetamin(-90) # only show top half
# ax.set_thetamax(90)
# plt.show()