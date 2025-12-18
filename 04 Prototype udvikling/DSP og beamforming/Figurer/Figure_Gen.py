import numpy as np
import matplotlib.pyplot as plt


fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})

for i in range(2, 7):
    Nr = i
    d = 0.5
    N_fft = 512
    theta_degrees = 0  # there is no SOI, we arent processing samples, this is just the direction we want to point at
    theta = theta_degrees / 180 * np.pi
    w = np.exp(2j * np.pi * d * np.arange(Nr) * np.sin(theta))  # conventional beamformer
    # zero pad to N_fft elements to get more resolution in the FFT
    w_padded = np.concatenate((w, np.zeros(N_fft - Nr)))
    w_fft_dB = 10*np.log10(np.abs(np.fft.fftshift(np.fft.fft(w_padded)))
                           ** 2)  # magnitude of fft in dB
    w_fft_dB -= np.max(w_fft_dB)  # normalize to 0 dB at peak

    # Map the FFT bins to angles in radians
    theta_bins = np.arcsin(np.linspace(-1, 1, N_fft))  # in radians

    # find max so we can add it to plot
    theta_max = theta_bins[np.argmax(w_fft_dB)]

    ax.plot(theta_bins, w_fft_dB, label=f'Elements = {Nr}')
    # ax.plot([theta_max], [np.max(w_fft_dB)], 'ro')
    # ax.text(theta_max - 0.1, np.max(w_fft_dB) - 4, np.round(theta_max * 180 / np.pi))
ax.set_theta_zero_location('N')  # make 0 degrees point up
ax.set_theta_direction(-1)  # increase clockwise
ax.set_rlabel_position(55)  # Move grid labels away from other labels
ax.set_thetamin(-90)  # only show top half
ax.set_thetamax(90)
ax.set_ylim([-30, 1])  # because there's no noise, only go down 30 dB

ax.legend(loc='upper right', bbox_to_anchor=(1.3, 1.1))
plt.show()


exit()
fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})


Nr = 2
d = 0.5
N_fft = 512
theta_degrees = 90  # there is no SOI, we arent processing samples, this is just the direction we want to point at
theta = theta_degrees / 180 * np.pi
w = np.exp(2j * np.pi * d * np.arange(Nr) * np.sin(theta))  # conventional beamformer
# zero pad to N_fft elements to get more resolution in the FFT
w_padded = np.concatenate((w, np.zeros(N_fft - Nr)))
w_fft_dB = 10*np.log10(np.abs(np.fft.fftshift(np.fft.fft(w_padded)))
                       ** 2)  # magnitude of fft in dB
w_fft_dB -= np.max(w_fft_dB)  # normalize to 0 dB at peak

# Map the FFT bins to angles in radians
theta_bins = np.arcsin(np.linspace(-1, 1, N_fft))  # in radians

# find max so we can add it to plot
theta_max = theta_bins[np.argmax(w_fft_dB)]

ax.plot(theta_bins, w_fft_dB, label=f'Elements = {Nr}')
# ax.plot([theta_max], [np.max(w_fft_dB)], 'ro')
# ax.text(theta_max - 0.1, np.max(w_fft_dB) - 4, np.round(theta_max * 180 / np.pi))
ax.set_theta_zero_location('N')  # make 0 degrees point up
ax.set_theta_direction(-1)  # increase clockwise
ax.set_rlabel_position(55)  # Move grid labels away from other labels
ax.set_thetamin(-90)  # only show top half
ax.set_thetamax(90)
ax.set_ylim([-30, 1])  # because there's no noise, only go down 30 dB

plt.show()


exit()
