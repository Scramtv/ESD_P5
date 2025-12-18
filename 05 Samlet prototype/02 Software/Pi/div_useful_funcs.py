import numpy as np
import matplotlib.pyplot as plt
from sdr_ctrl import sdr_ctrl
from time import sleep

from serial import Serial
from SerialRW.MotorComms import MotorCtrl
from bf import beamforming_das
from sdr_ctrl import sdr_ctrl
from time import sleep, time


def take_sample_and_save(sdr: sdr_ctrl, file_name: str):
    arr = sdr.sample(4096)
    arr = arr.T

    with open(file_name+'.txt', 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
    sdr.close()
    exit()

def plot_sample(sdr: sdr_ctrl, samples: int=4092):
    arr = sdr.sample(samples)
    arr = arr.T

    a = np.array([(pair[0].real) for pair in arr])
    b = np.array([(pair[1].real) for pair in arr])
    x = np.arange(len(arr))

    plt.figure()
    plt.plot(x, a)
    plt.title("abs(arr[i][0])")

    plt.figure()
    plt.plot(x, b)
    plt.title("abs(arr[i][1])")

    plt.show()
    sdr.close()
    exit()