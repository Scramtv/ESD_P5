#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Not titled yet
# Author: lille-koch
# GNU Radio version: 3.10.12.0

from gnuradio import analog
from gnuradio import blocks
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import network
from gnuradio import soapy
import threading




class Frontend(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Not titled yet", catch_exceptions=True)
        self.flowgraph_started = threading.Event()

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 61.44e6
        self.cent_freq = cent_freq = 2441.75e6
        self.band_pass = band_pass = 10e6
        self.RF_gain = RF_gain = 1

        ##################################################
        # Blocks
        ##################################################

        self.soapy_bladerf_source_0_0 = None
        dev = 'driver=bladerf'
        stream_args = ''
        tune_args = ['']
        settings = ['']

        self.soapy_bladerf_source_0_0 = soapy.source(dev, "fc32", 1, 'bladrf=0,channel=0',
                                  stream_args, tune_args, settings)
        self.soapy_bladerf_source_0_0.set_sample_rate(0, samp_rate)
        self.soapy_bladerf_source_0_0.set_bandwidth(0, band_pass)
        self.soapy_bladerf_source_0_0.set_frequency(0, cent_freq)
        self.soapy_bladerf_source_0_0.set_frequency_correction(0, 0)
        self.soapy_bladerf_source_0_0.set_gain(0, min(max(RF_gain, -1.0), 60.0))
        self.soapy_bladerf_source_0 = None
        dev = 'driver=bladerf'
        stream_args = ''
        tune_args = ['']
        settings = ['']

        self.soapy_bladerf_source_0 = soapy.source(dev, "fc32", 1, 'bladrf=0,channel=1',
                                  stream_args, tune_args, settings)
        self.soapy_bladerf_source_0.set_sample_rate(0, samp_rate)
        self.soapy_bladerf_source_0.set_bandwidth(0, band_pass)
        self.soapy_bladerf_source_0.set_frequency(0, cent_freq)
        self.soapy_bladerf_source_0.set_frequency_correction(0, 0)
        self.soapy_bladerf_source_0.set_gain(0, min(max(RF_gain, -1.0), 60.0))
        self.soapy_bladerf_sink_0 = None
        dev = 'driver=bladerf'
        stream_args = ''
        tune_args = ['']
        settings = ['']

        self.soapy_bladerf_sink_0 = soapy.sink(dev, "fc32", 1, 'bladrf=0',
                                  stream_args, tune_args, settings)
        self.soapy_bladerf_sink_0.set_sample_rate(0, samp_rate)
        self.soapy_bladerf_sink_0.set_bandwidth(0, band_pass)
        self.soapy_bladerf_sink_0.set_frequency(0, cent_freq)
        self.soapy_bladerf_sink_0.set_frequency_correction(0, 0)
        self.soapy_bladerf_sink_0.set_gain(0, min(max(1, 17.0), 73.0))
        self.network_tcp_sink_1 = network.tcp_sink(gr.sizeof_gr_complex, 1, '127.0.0.1', 5001,2)
        self.network_tcp_sink_0 = network.tcp_sink(gr.sizeof_gr_complex, 1, '127.0.0.1', 5000,2)
        self.blocks_file_sink_0_0_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/lille-koch/Desktop/Source.bin', False)
        self.blocks_file_sink_0_0_0.set_unbuffered(False)
        self.blocks_file_sink_0_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/lille-koch/Desktop/AT 2.bin', False)
        self.blocks_file_sink_0_0.set_unbuffered(False)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/lille-koch/Desktop/At 1.bin', False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, 1000, 0.5, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_file_sink_0_0_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.soapy_bladerf_sink_0, 0))
        self.connect((self.soapy_bladerf_source_0, 0), (self.blocks_file_sink_0_0, 0))
        self.connect((self.soapy_bladerf_source_0, 0), (self.network_tcp_sink_1, 0))
        self.connect((self.soapy_bladerf_source_0_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.soapy_bladerf_source_0_0, 0), (self.network_tcp_sink_0, 0))


    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.soapy_bladerf_sink_0.set_sample_rate(0, self.samp_rate)
        self.soapy_bladerf_source_0.set_sample_rate(0, self.samp_rate)
        self.soapy_bladerf_source_0_0.set_sample_rate(0, self.samp_rate)

    def get_cent_freq(self):
        return self.cent_freq

    def set_cent_freq(self, cent_freq):
        self.cent_freq = cent_freq
        self.soapy_bladerf_sink_0.set_frequency(0, self.cent_freq)
        self.soapy_bladerf_source_0.set_frequency(0, self.cent_freq)
        self.soapy_bladerf_source_0_0.set_frequency(0, self.cent_freq)

    def get_band_pass(self):
        return self.band_pass

    def set_band_pass(self, band_pass):
        self.band_pass = band_pass
        self.soapy_bladerf_sink_0.set_bandwidth(0, self.band_pass)
        self.soapy_bladerf_source_0.set_bandwidth(0, self.band_pass)
        self.soapy_bladerf_source_0_0.set_bandwidth(0, self.band_pass)

    def get_RF_gain(self):
        return self.RF_gain

    def set_RF_gain(self, RF_gain):
        self.RF_gain = RF_gain
        self.soapy_bladerf_source_0.set_gain(0, min(max(self.RF_gain, -1.0), 60.0))
        self.soapy_bladerf_source_0_0.set_gain(0, min(max(self.RF_gain, -1.0), 60.0))




def main(top_block_cls=Frontend, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()
    tb.flowgraph_started.set()

    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
