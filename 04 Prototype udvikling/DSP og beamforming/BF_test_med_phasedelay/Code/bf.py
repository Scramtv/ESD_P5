import numpy as np


def beamforming_das(rx, distance, no_ele):
    # Deler -pi/2 til pi/2 op i 1000 segmenter og gemmer i et array
    theta_sweep = np.linspace(-1*np.pi/2, np.pi/2, 1000)
    results = []  # Laver tomt array til resultater
    for thetas in theta_sweep:  # For alle de værdier i theta sweep, kører vi
        # Weight vektor tilsvarende "steering vektoren" køres for theta
        w = np.exp(2j * np.pi * distance * np.arange(no_ele) * np.sin(thetas))
        y = w.conj().T @ rx  # Vi kompleks konjugere for at modarbejde faseforskydningen og transponerer så matricen har den rigtige form
        # Vi finder modulus af de to beamformede datapunkter og gemmer dem i arrayet
        results.append(np.abs(np.sum(y)))
    # Vi kigger efter den theta hvor amplituden er størst og returnere den i grader
    return np.rad2deg(theta_sweep[np.argmax(results)])
