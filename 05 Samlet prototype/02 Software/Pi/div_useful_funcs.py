import numpy as np
import matplotlib.pyplot as plt
from sdr_ctrl import sdr_ctrl
from time import sleep

def take_sample_and_save(sdr: sdr_ctrl):
    arr = sdr.sample(4096)
    arr = arr.T

    with open('RX2_200mV_2500MHZ.txt', 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
    sdr.close()
    exit()

def plot_sample(sdr: sdr_ctrl):
    arr = sdr.sample(4096)
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