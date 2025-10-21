"""
Embedded Python Blocks:

Each time this file is saved, GRC will instantiate the first class it finds
to get ports and parameters of your block. The arguments to __init__  will
be the parameters. All of them are required to have default values!
"""
from operator import truediv

import numpy as np
from gnuradio import gr


class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block - Control block"""

    def __init__(self):  # only default arguments here
        """arguments to this function show up as parameters in GRC"""
        gr.sync_block.__init__(
            self,
            name='Switch Channel',   # will show up in GRC
            in_sig=[np.float32, np.float32],
            out_sig=[np.float32, np.float32]
        )
        self.cent_freq = [2413.916*10**6, 2441.75*10**6, 2469.583*10**6] #center frequencies
        self.index = 0

        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).


    def start(self): #Define start conditions - called when the flowgrahf is called
        self.set_freq(self.cent_freq[self.index])

    def work(self, cent_freq):
        try:
            self.tb.get_block('osmocom_scr').set_center_freq(cent_freq, 0)

        except:
            print("Error, could not set center freq - muhhhhhhhhhhhhhhhhhhhhhh")




    def work(self, input_items, output_items): #is the main loop
        in_flag_move_done = input_items[0] #Input flag that the movement is done
        in_flag_samp_done = input_items[1] #Input flag that the samples have been taken
        out_flag_meas_done = output_items[0] #Output flag all channeles have been sampled
        out_flag_samp_now = output_items[1] #Output flag take new samp at new channel
        channel_sweep = 0

        for i in range(len(input_items[0])): #The loop runs for the length of input_times[0] size which is determind by GNU
            if in_flag_move_done[i] > 0.5:
                out_flag_meas_done[i] = 0.0

                while channel_sweep < 2:

                    if in_flag_samp_done[i] > 0.5:
                        self.index += 1
                        self.set_freq(self.cent_freq[i])
                        channel_sweep += 1
                        out_flag_samp_now[i] = 1.0
                        
                    
            channel_sweep = 0
            out_flag_meas_done[i] = 1.0
        
        return len(input_items[0])