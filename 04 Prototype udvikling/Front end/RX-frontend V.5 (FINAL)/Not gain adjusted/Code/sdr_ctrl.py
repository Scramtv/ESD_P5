import numpy as np
from bladerf import _bladerf
import numpy as np

class sdr_ctrl:
    def __init__(self, sample_rate:int, center_freq:int, gain:int):
        self.sdr = _bladerf.BladeRF()
        self.sample_rate = sample_rate
        self.center_freq = center_freq
        self.gain = gain

        self.buffer_size = 8192

        # --- Setup RX1 ---
        self.rx1 = self.sdr.Channel(_bladerf.CHANNEL_RX(0))
        self.rx1.frequency = center_freq
        self.rx1.sample_rate = sample_rate
        self.rx1.bandwidth = sample_rate / 2
        self.rx1.gain_mode = _bladerf.GainMode.Manual
        self.rx1.gain = gain

        # --- Setup RX2 ---
        self.rx2 = self.sdr.Channel(_bladerf.CHANNEL_RX(1))
        self.rx2.frequency = center_freq
        self.rx2.sample_rate = sample_rate
        self.rx2.bandwidth = sample_rate / 2
        self.rx2.gain_mode = _bladerf.GainMode.Manual
        self.rx2.gain = gain

        # --- Configure one synchronous 2 RX stream ---
        self.sdr.sync_config(
            layout=_bladerf.ChannelLayout.RX_X2,
            fmt=_bladerf.Format.SC16_Q11,
            num_buffers=16,
            buffer_size=self.buffer_size,
            num_transfers=8,
            stream_timeout=3500,
        )

        self.bytes_per_sample = 4  # SC16_Q11: 2 x int16 = 4 bytes - don't change this, it will always use int16s
        self.buf = bytearray(self.buffer_size * self.bytes_per_sample * 2)  # *2 due to two channels (Rx1 + Rx2)


        # Enable both channels
        self.rx1.enable = True
        self.rx2.enable = True


    def sample(self, num_samples:int):
        # Storage
        x1 = np.zeros(num_samples, dtype=np.complex64)
        x2 = np.zeros(num_samples, dtype=np.complex64)

        samples_read = 0

        while samples_read < num_samples:
            # expected samples:
            max_samps = min(self.buffer_size, num_samples - samples_read)

            # Buffer recv (I1,Q1,I2,Q2)
            self.sdr.sync_rx(self.buf, max_samps*2) # *2 fordi der er to bytes på en int16

            # Int16 array: [I1,Q1,I2,Q2,I1,Q1,I2,Q2,...]
            raw = np.frombuffer(self.buf, dtype=np.int16)

            # Reshape to [4, N] buffer I.e. matrix, row0 = I1, Row1=Q1, Row2=I2, Row3=Q2
            raw = raw.reshape(-1, 4).T

            # Converting to complex samples
            c1 = (raw[0] + 1j * raw[1]) / 2048.0
            c2 = (raw[2] + 1j * raw[3]) / 2048.0

            # Saving for later use
            x1[samples_read : samples_read + max_samps] = c1[:max_samps]
            x2[samples_read : samples_read + max_samps] = c2[:max_samps]

            samples_read += max_samps

        arr = np.vstack([x1,x2])
        return arr

    def close(self):
        self.rx1.enable = False
        self.rx2.enable = False