import numpy as np
from gnuradio import gr

class blk(gr.sync_block):
    def __init__(self):
        gr.sync_block.__init__(
            self,<
            name="50Samples",
            in_sig=[np.complex64, np.float32],
            out_sig=[np.complex64, np.float32]
        )
        self.count = 0

    def work(self, input_items, output_items):
        in_data = input_items[0]
        in_flag = input_items[1]
        out_data = output_items[0]
        out_flag = output_items[1]

        n_input_data = len(in_data)
        n_input_flag = len(in_flag)
        n_output_data = len(out_data)
        n_output_flag = len(out_flag)

        samples_written = 0

        for i in range(min(n_input_data, n_input_flag, n_output_data, n_output_flag)):
            if in_flag[i] > 0.5:
            
                if self.count < 50:
                        out_data[samples_written] = in_data[i]
                        out_flag[samples_written] = 0.0
                        self.count += 1
                        samples_written += 1

                if self.count < 60:
                        out_flag[samples_written] = 1.0
                        self.count += 1
                        samples_written += 1
                else:
                        break
     
            else:
                samples_writtesn = 0
                break

        return samples_written