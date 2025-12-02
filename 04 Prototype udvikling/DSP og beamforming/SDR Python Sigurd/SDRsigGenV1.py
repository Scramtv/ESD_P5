#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from PyQt5 import Qt
from gnuradio import qtgui
from PyQt5 import QtCore
from gnuradio import analog
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from PyQt5 import Qt
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import soapy
import sip



class untitled(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Not titled yet", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Not titled yet")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except BaseException as exc:
            print(f"Qt GUI: Could not set Icon: {str(exc)}", file=sys.stderr)
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "untitled")

        try:
            geometry = self.settings.value("geometry")
            if geometry:
                self.restoreGeometry(geometry)
        except BaseException as exc:
            print(f"Qt GUI: Could not restore geometry: {str(exc)}", file=sys.stderr)

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 15.4e6
        self.Gain = Gain = 23
        self.Frequency = Frequency = 2.05e9
        self.Freq = Freq = 1e3
        self.Bandwidth = Bandwidth = 1e3
        self.Amplitude = Amplitude = 10

        ##################################################
        # Blocks
        ##################################################

        self._Gain_range = qtgui.Range(0, 70, 1, 23, 200)
        self._Gain_win = qtgui.RangeWidget(self._Gain_range, self.set_Gain, "'Gain'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._Gain_win)
        self._Frequency_range = qtgui.Range(1e9, 4e9, 2e6, 2.05e9, 200)
        self._Frequency_win = qtgui.RangeWidget(self._Frequency_range, self.set_Frequency, "'Frequency'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._Frequency_win)
        self._Freq_range = qtgui.Range(0, 50e3, 100, 1e3, 200)
        self._Freq_win = qtgui.RangeWidget(self._Freq_range, self.set_Freq, "'Freq'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._Freq_win)
        self._Bandwidth_range = qtgui.Range(1e3, 38e6, 10e3, 1e3, 200)
        self._Bandwidth_win = qtgui.RangeWidget(self._Bandwidth_range, self.set_Bandwidth, "'Bandwidth'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._Bandwidth_win)
        self._Amplitude_range = qtgui.Range(0, 100, 1, 10, 200)
        self._Amplitude_win = qtgui.RangeWidget(self._Amplitude_range, self.set_Amplitude, "'Amplitude'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._Amplitude_win)
        self.soapy_bladerf_sink_0 = None
        dev = 'driver=bladerf'
        stream_args = ''
        tune_args = ['']
        settings = ['']

        self.soapy_bladerf_sink_0 = soapy.sink(dev, "fc32", 1, "bladerf=0",
                                  stream_args, tune_args, settings)
        self.soapy_bladerf_sink_0.set_sample_rate(0, samp_rate)
        self.soapy_bladerf_sink_0.set_bandwidth(0, Bandwidth)
        self.soapy_bladerf_sink_0.set_frequency(0, Frequency)
        self.soapy_bladerf_sink_0.set_frequency_correction(0, 0)
        self.soapy_bladerf_sink_0.set_gain(0, min(max(Gain, 17.0), 73.0))
        self.qtgui_waterfall_sink_x_0 = qtgui.waterfall_sink_c(
            1024, #size
            window.WIN_BLACKMAN_hARRIS, #wintype
            Frequency, #fc
            Bandwidth, #bw
            "", #name
            1, #number of inputs
            None # parent
        )
        self.qtgui_waterfall_sink_x_0.set_update_time(0.10)
        self.qtgui_waterfall_sink_x_0.enable_grid(False)
        self.qtgui_waterfall_sink_x_0.enable_axis_labels(True)



        labels = ['', '', '', '', '',
                  '', '', '', '', '']
        colors = [0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]

        for i in range(1):
            if len(labels[i]) == 0:
                self.qtgui_waterfall_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_waterfall_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_waterfall_sink_x_0.set_color_map(i, colors[i])
            self.qtgui_waterfall_sink_x_0.set_line_alpha(i, alphas[i])

        self.qtgui_waterfall_sink_x_0.set_intensity_range(-140, 10)

        self._qtgui_waterfall_sink_x_0_win = sip.wrapinstance(self.qtgui_waterfall_sink_x_0.qwidget(), Qt.QWidget)

        self.top_layout.addWidget(self._qtgui_waterfall_sink_x_0_win)
        self.qtgui_freq_sink_x_0 = qtgui.freq_sink_c(
            1024, #size
            window.WIN_BLACKMAN_hARRIS, #wintype
            Frequency, #fc
            Bandwidth, #bw
            "", #name
            1,
            None # parent
        )
        self.qtgui_freq_sink_x_0.set_update_time(0.10)
        self.qtgui_freq_sink_x_0.set_y_axis((-140), 10)
        self.qtgui_freq_sink_x_0.set_y_label('Relative Gain', 'dB')
        self.qtgui_freq_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, 0.0, 0, "")
        self.qtgui_freq_sink_x_0.enable_autoscale(False)
        self.qtgui_freq_sink_x_0.enable_grid(False)
        self.qtgui_freq_sink_x_0.set_fft_average(1.0)
        self.qtgui_freq_sink_x_0.enable_axis_labels(True)
        self.qtgui_freq_sink_x_0.enable_control_panel(False)
        self.qtgui_freq_sink_x_0.set_fft_window_normalized(False)



        labels = ['', '', '', '', '',
            '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
            "magenta", "yellow", "dark red", "dark green", "dark blue"]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0]

        for i in range(1):
            if len(labels[i]) == 0:
                self.qtgui_freq_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_freq_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_freq_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_freq_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_freq_sink_x_0.set_line_alpha(i, alphas[i])

        self._qtgui_freq_sink_x_0_win = sip.wrapinstance(self.qtgui_freq_sink_x_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_freq_sink_x_0_win)
        self.analog_sig_source_x_1 = analog.sig_source_c(samp_rate, analog.GR_SIN_WAVE, Freq, Amplitude, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_1, 0), (self.qtgui_freq_sink_x_0, 0))
        self.connect((self.analog_sig_source_x_1, 0), (self.qtgui_waterfall_sink_x_0, 0))
        self.connect((self.analog_sig_source_x_1, 0), (self.soapy_bladerf_sink_0, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "untitled")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_1.set_sampling_freq(self.samp_rate)
        self.soapy_bladerf_sink_0.set_sample_rate(0, self.samp_rate)

    def get_Gain(self):
        return self.Gain

    def set_Gain(self, Gain):
        self.Gain = Gain
        self.soapy_bladerf_sink_0.set_gain(0, min(max(self.Gain, 17.0), 73.0))

    def get_Frequency(self):
        return self.Frequency

    def set_Frequency(self, Frequency):
        self.Frequency = Frequency
        self.qtgui_freq_sink_x_0.set_frequency_range(self.Frequency, self.Bandwidth)
        self.qtgui_waterfall_sink_x_0.set_frequency_range(self.Frequency, self.Bandwidth)
        self.soapy_bladerf_sink_0.set_frequency(0, self.Frequency)

    def get_Freq(self):
        return self.Freq

    def set_Freq(self, Freq):
        self.Freq = Freq
        self.analog_sig_source_x_1.set_frequency(self.Freq)

    def get_Bandwidth(self):
        return self.Bandwidth

    def set_Bandwidth(self, Bandwidth):
        self.Bandwidth = Bandwidth
        self.qtgui_freq_sink_x_0.set_frequency_range(self.Frequency, self.Bandwidth)
        self.qtgui_waterfall_sink_x_0.set_frequency_range(self.Frequency, self.Bandwidth)
        self.soapy_bladerf_sink_0.set_bandwidth(0, self.Bandwidth)

    def get_Amplitude(self):
        return self.Amplitude

    def set_Amplitude(self, Amplitude):
        self.Amplitude = Amplitude
        self.analog_sig_source_x_1.set_amplitude(self.Amplitude)




def main(top_block_cls=untitled, options=None):

    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
