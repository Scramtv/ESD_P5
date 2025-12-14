import numpy as np
from bladerf import _bladerf

class sdr_ctrl:
    def __init__(self, sample_rate: int, center_freq: int):
        self.sdr = _bladerf.BladeRF()
        self.sample_rate = sample_rate
        self.center_freq = center_freq

        self.buffer_size = 8192

        # --- Setup RX1 ---
        self.rx1 = self.sdr.Channel(_bladerf.CHANNEL_RX(0))
        self.rx1.frequency = center_freq
        self.rx1.sample_rate = sample_rate
        self.rx1.bandwidth = sample_rate
        self.rx1.gain_mode = _bladerf.GainMode.Manual
        self.rx1.gain = 0

        # --- Setup RX2 ---
        self.rx2 = self.sdr.Channel(_bladerf.CHANNEL_RX(1))
        self.rx2.frequency = center_freq
        self.rx2.sample_rate = sample_rate
        self.rx2.bandwidth = sample_rate
        self.rx2.gain_mode = _bladerf.GainMode.Manual
        self.rx2.gain = 20

        # --- Configure one synchronous 2 RX stream ---
        self.sdr.sync_config(
            layout=_bladerf.ChannelLayout.RX_X2,  # Layout is 2 RX
            fmt=_bladerf.Format.SC16_Q11,  # Data format is Signed Complex 16bit
            # Q11 = fixed-point scaling. The 16 bits are split into 1 sign bit, 4 integer, and 11 decimals.
            num_buffers=16,  # buffer amount
            buffer_size=self.buffer_size,  # Size of buffer
            num_transfers=8,  # Amount of transferes active.
            stream_timeout=3500,  # Timeout, after this time, python will crash
        )

        self.bytes_per_sample = 4  # SC16_Q11: 2 x int16 = 4 bytes
        self.buf = bytearray(self.buffer_size * self.bytes_per_sample *2)  # *2 due to two channels (Rx1 + Rx2)

        # Enable both channels
        self.rx1.enable = True
        self.rx2.enable = True

    def sample(self, num_samples: int):
        # Storage (Sets to zero)
        x1 = np.zeros(num_samples, dtype=np.complex64)
        x2 = np.zeros(num_samples, dtype=np.complex64)

        samples_read = 0  # How many samples have been read?

        while samples_read < num_samples:
            # amount of samples to take
            max_samps = min(self.buffer_size, num_samples - samples_read)

            # Fill buffer with samples
            self.sdr.sync_rx(self.buf, max_samps*2)  # *2 because there is 2 bytes in an int16

            # Convert from buffer to ints
            raw = np.frombuffer(self.buf, dtype=np.int16)

            # Reshape to [4, N] buffer
            # I.e. matrix, row0 = I1, Row1=Q1, Row2=I2, Row3=Q2
            raw = raw.reshape(-1, 4).T

            # Converting to complex samples
            c1 = (raw[0] + 1j * raw[1]) / 2048.0  # 2048 = Scale to -1 to 1 (12 bit ADC)
            c2 = (raw[2] + 1j * raw[3]) / 2048.0

            # Saving samples
            x1[samples_read: samples_read + max_samps] = c1[:max_samps]
            x2[samples_read: samples_read + max_samps] = c2[:max_samps]

            samples_read += max_samps  # How many samples have we read?

        arr = np.vstack([x1, x2])  # Stack the two arrays to one array
        return arr

    def close(self):
        self.rx1.enable = False
        self.rx2.enable = False
