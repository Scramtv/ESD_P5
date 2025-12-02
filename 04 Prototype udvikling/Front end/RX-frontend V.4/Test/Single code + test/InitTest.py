from bladerf import _bladerf #NB den påstår dette ikke eksistere, men det gør det altså :/
import numpy as np

sdr = _bladerf.BladeRF()

sample_rate = 1.44e6
center_freq = 2.44175e9
gain = 0 # -15 to 60 dB
num_samples = int(1e6)

rx_ch1 = sdr.Channel(_bladerf.CHANNEL_RX(0))
rx_ch1.frequency = center_freq
rx_ch1.sample_rate = sample_rate
rx_ch1.bandwidth = sample_rate/2
rx_ch1.gain_mode = _bladerf.GainMode.Manual
rx_ch1.gain = gain

# Setup synchronous stream
sdr.sync_config(layout = _bladerf.ChannelLayout.RX_X1, # or RX_X2
                fmt = _bladerf.Format.SC16_Q11, # int16s
                num_buffers    = 16,
                buffer_size    = 8192,
                num_transfers  = 8,
                stream_timeout = 3500)

# Create receive buffer
bytes_per_sample = 4 # don't change this, it will always use int16s
buf = bytearray(1024 * bytes_per_sample)

# Enable module
print("Starting receive")
rx_ch1.enable = True

# Receive loop
x = np.zeros(num_samples, dtype=np.complex64) # storage for IQ samples
num_samples_read = 0
while True:
    if num_samples > 0 and num_samples_read == num_samples:
        break
    elif num_samples > 0:
        num = min(len(buf) // bytes_per_sample, num_samples - num_samples_read)
    else:
        num = len(buf) // bytes_per_sample
    sdr.sync_rx(buf, num) # Read into buffer
    samples = np.frombuffer(buf, dtype=np.int16)
    samples = samples[0::2] + 1j * samples[1::2] # Convert to complex type
    samples /= 2048.0 # Scale to -1 to 1 (its using 12 bit ADC)
    x[num_samples_read:num_samples_read+num] = samples[0:num] # Store buf in samples array
    num_samples_read += num

print("Stopping")
rx_ch1.enable = False
print(x[0:10]) # look at first 10 IQ samples
print(np.max(x)) # if this is close to 1, you are overloading the ADC, and should reduce the gain


with open('RF2442MHZ.txt', 'a') as f:
    for item in x:
        f.write(str(item)+'\n')

exit()