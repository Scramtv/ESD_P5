import numpy as np

def beamforming_das(rx, distance, no_ele):
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 1000) # Deler -pi/2 til pi/2 op i 1000 segmenter og gemmer i et array
    results = [] # Laver tomt array til resultater
    for thetas in theta_sweep: # For alle de værdier i theta sweep, kører vi
       w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas)) # Weight vektor tilsvarende "steering vektoren" køres for theta
       y = w.conj().T @ rx # Vi kompleks konjugere for at modarbejde faseforskydningen og transponerer så matricen har den rigtige form
       results.append(np.abs(np.sum(y))) # Vi finder modulus af de to beamformede datapunkter summeret og gemmer dem i arrayet
    return np.rad2deg(theta_sweep[np.argmax(results)]) # Vi kigger efter den theta hvor amplituden er størst og returnerer den i grader

sample_rate = 61.44e6
N = 10000
t = np.arange(N)/sample_rate

### TX SIGNAL
theta_deg = 0 # Angle of arrival
theta_rad = np.deg2rad(theta_deg)
f = 2e4
tx = np.exp(2j * np.pi * f * t)
d = 0.5
elements = 2
k = np.arange(elements)
s = np.exp(2j * np.pi * d * k * np.sin(theta_rad))
s = s.reshape(-1,1)
tx = tx.reshape(1,-1)

### RX SIGNAL
X = s @ tx
n = np.random.randn(elements, N) + 1j*np.random.randn(elements, N)
X_n = X + 0.0 * n

### FUNCTIONALITY TEST
bf_signal = beamforming_das(X_n, d, elements)
print(bf_signal)