"""
Embedded Python Blocks:

Each time this file is saved, GRC will instantiate the first class it finds
to get ports and parameters of your block. The arguments to __init__  will
be the parameters. All of them are required to have default values!
"""

import numpy as np
from gnuradio import gr


class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block that takes samples passes them, when a input flag does high then it will tka 50 new"""

    def __init__(self, Numb_Sample = 1.0):  # only default arguments here
        gr.sync_block.__init__(
            self,
            name = 'Samples',   # will show up in GRC
            in_sig=[np.complex64, np.complex64, np.float32],
            out_sig=[np.complex64, np.complex64, np.float32]
        )
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).
        self.Numb_Sample = Numb_Sample

    def work(self, input_items, output_items):
        in_data_port1 = input_items[0]
        in_data_port2 = input_items[1]
        in_flag_move_done = input_items[2]

        counter = 0
        
        if in_flag_move_done> 0.5:
            while (counter < self.Numb_Sample):
                counter += 1
                output_items[0]=in_data_port1
                output_items[1]=in_data_port2
            output_items[2]=1.0
            counter=0

        return
