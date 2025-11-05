"""
Embedded Python Blocks:

Each time this file is saved, GRC will instantiate the first class it finds
to get ports and parameters of your block. The arguments to __init__  will
be the parameters. All of them are required to have default values!
"""
from operator import index

import numpy as np
from gnuradio import gr


class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block that takes samples passes them, when a input flag does high then it will tka 50 new"""

    def __init__(self):  # only default arguments here
        gr.sync_block.__init__(
            self,
            name = 'Samples',   # will show up in GRC
            in_sig=[np.complex64, np.complex64, np.float32], #RX1, RX2, Flag_move
            out_sig=[np.complex64, np.complex64, np.float32] #RX1, RX2, Flag_meas_done
        )
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).


    def work(self, input_items, output_items):

        out_items = 0
        for i in range(len(input_items[0])):
            if input_items[2][i] > 0.5:
                output_items[0][i] = input_items[0][i]
                output_items[1][i] = input_items[1][i]
                output_items[2][i] = 0.0
                out_items += 1
            else:

                output_items[0][i] = 0
                output_items[1][i] = 0

            output_items[2][i] = 1.0


        return out_items