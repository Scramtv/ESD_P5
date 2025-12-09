import numpy as np
from sdr_ctrl import sdr_ctrl

sdr = sdr_ctrl(61.44e6, 2.44175e9, 0)
arr = sdr.sample(8192)

arr = arr.T

with open('Noise.txt', 'a') as f:
    for index, item in enumerate(arr):
        f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
sdr.close()
