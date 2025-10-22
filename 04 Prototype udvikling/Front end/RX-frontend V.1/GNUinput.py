#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Data_In
# Author: Grp 5-125
# Copyright: Yes
# Description: No
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
import GNUinput_epy_block_0 as epy_block_0  # embedded python block
import GNUinput_epy_block_0_0 as epy_block_0_0  # embedded python block
import osmosdr
import time
import threading




class GNUinput(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Data_In", catch_exceptions=True)
        self.flowgraph_started = threading.Event()

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 41.75e6
        self.pass_band = pass_band = 27.83e6
        self.cent_freq = cent_freq = 2413.916e6

        ##################################################
        # Blocks
        ##################################################

        self.osmosdr_source_0 = osmosdr.source(
            args="numchan=" + str(2) + " " + 'bladerf=0,nchan=2'
        )
        self.osmosdr_source_0.set_time_unknown_pps(osmosdr.time_spec_t())
        self.osmosdr_source_0.set_sample_rate(samp_rate)
        self.osmosdr_source_0.set_center_freq(cent_freq, 0)
        self.osmosdr_source_0.set_freq_corr(0, 0)
        self.osmosdr_source_0.set_dc_offset_mode(0, 0)
        self.osmosdr_source_0.set_iq_balance_mode(0, 0)
        self.osmosdr_source_0.set_gain_mode(False, 0)
        self.osmosdr_source_0.set_gain(0, 0)
        self.osmosdr_source_0.set_if_gain(0, 0)
        self.osmosdr_source_0.set_bb_gain(0, 0)
        self.osmosdr_source_0.set_antenna('', 0)
        self.osmosdr_source_0.set_bandwidth(pass_band, 0)
        self.osmosdr_source_0.set_center_freq(cent_freq, 1)
        self.osmosdr_source_0.set_freq_corr(0, 1)
        self.osmosdr_source_0.set_dc_offset_mode(0, 1)
        self.osmosdr_source_0.set_iq_balance_mode(0, 1)
        self.osmosdr_source_0.set_gain_mode(False, 1)
        self.osmosdr_source_0.set_gain(0, 1)
        self.osmosdr_source_0.set_if_gain(0, 1)
        self.osmosdr_source_0.set_bb_gain(0, 1)
        self.osmosdr_source_0.set_antenna('', 1)
        self.osmosdr_source_0.set_bandwidth(pass_band, 1)
        self.osmosdr_source_0.set_block_alias("osmocom_src")
        self.epy_block_0_0 = epy_block_0_0.blk()
        self.epy_block_0 = epy_block_0.blk()
        self.blocks_null_sink_0_0 = blocks.null_sink(gr.sizeof_float*1)
        self.blocks_null_sink_0 = blocks.null_sink(gr.sizeof_float*1)
        self.blocks_file_sink_0_1 = blocks.file_sink(gr.sizeof_gr_complex*1, 'C:\\Users\\solva\\Desktop\\GitHub\\ESD5\\ESD_P5\\04 Prototype udvikling\\Front end\\RX-frontend V.1\\Data_test1.txt', False)
        self.blocks_file_sink_0_1.set_unbuffered(True)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, 'C:\\Users\\solva\\Desktop\\GitHub\\ESD5\\ESD_P5\\04 Prototype udvikling\\Front end\\RX-frontend V.1\\Data_test.txt', False)
        self.blocks_file_sink_0.set_unbuffered(True)
        self.analog_const_source_x_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.epy_block_0, 1))
        self.connect((self.analog_const_source_x_0, 0), (self.epy_block_0_0, 1))
        self.connect((self.epy_block_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.epy_block_0, 1), (self.blocks_null_sink_0_0, 0))
        self.connect((self.epy_block_0_0, 0), (self.blocks_file_sink_0_1, 0))
        self.connect((self.epy_block_0_0, 1), (self.blocks_null_sink_0, 0))
        self.connect((self.osmosdr_source_0, 0), (self.epy_block_0, 0))
        self.connect((self.osmosdr_source_0, 1), (self.epy_block_0_0, 0))


    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.osmosdr_source_0.set_sample_rate(self.samp_rate)

    def get_pass_band(self):
        return self.pass_band

    def set_pass_band(self, pass_band):
        self.pass_band = pass_band
        self.osmosdr_source_0.set_bandwidth(self.pass_band, 0)
        self.osmosdr_source_0.set_bandwidth(self.pass_band, 1)

    def get_cent_freq(self):
        return self.cent_freq

    def set_cent_freq(self, cent_freq):
        self.cent_freq = cent_freq
        self.osmosdr_source_0.set_center_freq(self.cent_freq, 0)
        self.osmosdr_source_0.set_center_freq(self.cent_freq, 1)




def main(top_block_cls=GNUinput, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()
    tb.flowgraph_started.set()

    tb.wait()


if __name__ == '__main__':
    main()
