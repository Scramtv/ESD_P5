from bladerf import _bladerf
import numpy as np

sdr = _bladerf.BladeRF()

sample_rate = 1.44e6
center_freq = 2.44175e9
gain = 0
num_samples = int(1e6)

bytes_per_sample = 4  # SC16_Q11: 2 x int16 = 4 bytes - don't change this, it will always use int16s

# --- Setup RX1 ---
rx1 = sdr.Channel(_bladerf.CHANNEL_RX(0))
rx1.frequency = center_freq
rx1.sample_rate = sample_rate
rx1.bandwidth = sample_rate / 2
rx1.gain_mode = _bladerf.GainMode.Manual
rx1.gain = gain

# --- Setup RX2 ---
rx2 = sdr.Channel(_bladerf.CHANNEL_RX(1))
rx2.frequency = center_freq
rx2.sample_rate = sample_rate
rx2.bandwidth = sample_rate / 2
rx2.gain_mode = _bladerf.GainMode.Manual
rx2.gain = gain

# --- Configure one synchronous 2 RX stream ---
sdr.sync_config(
    layout=_bladerf.ChannelLayout.RX_X2,
    fmt=_bladerf.Format.SC16_Q11,
    num_buffers=16,
    buffer_size=8192,
    num_transfers=8,
    stream_timeout=3500,
)

buf = bytearray(8192 * bytes_per_sample * 2)  # *2 due to two channels (Rx1 + Rx2)

# Enable both channels
rx1.enable = True
rx2.enable = True

# Storage
x1 = np.zeros(num_samples, dtype=np.complex64)
x2 = np.zeros(num_samples, dtype=np.complex64)

samples_read = 0

while samples_read < num_samples:
    # expected samples:
    max_samps = min(8192, num_samples - samples_read)

    # Buffer recv (I1,Q1,I2,Q2)
    sdr.sync_rx(buf, max_samps)

    # Int16 array: [I1,Q1,I2,Q2,I1,Q1,I2,Q2,...]
    raw = np.frombuffer(buf, dtype=np.int16)

    # Reshape to [4, N] buffer I.e. matrix, row0 = I1, Row1=Q1, Row2=I2, Row3=Q2
    raw = raw.reshape(-1, 4).T

    # Converting to complex samples
    c1 = (raw[0] + 1j * raw[1]) / 2048.0
    c2 = (raw[2] + 1j * raw[3]) / 2048.0

    # Saving for later use
    x1[samples_read : samples_read + max_samps] = c1[:max_samps]
    x2[samples_read : samples_read + max_samps] = c2[:max_samps]

    samples_read += max_samps

rx1.enable = False
rx2.enable = False

print(x1[:10])
print(x2[:10])




with open('Two_NoRFl.txt', 'a') as f:
    for index, item in enumerate(x1):
        f.write(str(x1[index])+";"+str(x2[index])+'\n')

exit()