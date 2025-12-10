import numpy as np

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 1000)
    results = []
    for thetas in theta_sweep:
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
       y = w.conj().T @ rx
       results.append(np.abs(np.sum(y)))
    return np.rad2deg(theta_sweep[np.argmax(results)])

sample_rate = 61.44e6
N = 10000 # samples to take
t = np.arange(N)/sample_rate # time

### TX SIGNAL
theta_deg = 0 # angle of arrival
theta_rad = np.deg2rad(theta_deg)
f = 2e4 # baseband signal frequency
tx = np.exp(2j * np.pi * f * t) # x(t) baseband signal

### ARRAY
elements = 2
d = 0.5 # distance in wavelengths between elements
k = np.arange(elements) # element index
s = np.exp(2j * np.pi * d * k * np.sin(theta_rad)) # steering vector
s = s.reshape(-1,1) # reshape s into a column vector
tx = tx.reshape(1,-1) # reshape tx into a row vector

### RX SIGNAL
X = s @ tx # matrix multiply the steering vector on the transmit signal to make the received signal
n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N) #generate real and imaginary awgn
X_n = X + 0.1 * n # apply noise to the received signal

### FUNCTIONALITY TEST
bf_signal = beamforming_das(X_n, d, elements)
print(bf_signal)