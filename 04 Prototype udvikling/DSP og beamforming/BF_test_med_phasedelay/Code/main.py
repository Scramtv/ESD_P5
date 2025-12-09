import numpy as np
import matplotlib.pyplot as plt
from bladerf import _bladerf
import numpy as np
from serial import Serial

from SerialRW.MotorComms import MotorCtrl
from bf import beamforming_das
from sdr_ctrl import sdr_ctrl
from time import sleep
#sleep(5)
sdr = sdr_ctrl(40e6, 2.44175e9)  # 61.44e6
#sdr = sdr_ctrl(1e6, 2.44e9, 40)
#esp = Serial(port='/dev/ttyUSB0', baudrate=115200, timeout=1)
#motor = MotorCtrl(esp)

i=0
bfs = []
deg = -135
while True:
    i=i+1
    arr = sdr.sample(4) #4096
    bf = beamforming_das(arr, 0.5, 2)
    print("bf: ", bf)
    bfs.append(bf)
    
    arr = arr.T
    with open(str('BF_data_'+str(deg)+'deg'+str(i)+".txt"), 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
    if i>=5:
        with open('BF_results_'+str(deg)+'deg.txt', 'a') as f:
            for item in bfs:
                f.write(str(item)+'\n')
        sdr.close()
        exit()

exit()



arr = sdr.sample(400) # 4096


arr = arr.T


a = np.array([(pair[0].real) for pair in arr])
b = np.array([(pair[1].real) for pair in arr])
x = np.arange(len(arr))

import matplotlib.pyplot as plt

plt.figure()
plt.plot(x, a)
plt.plot(x,b)
plt.show()
exit()







motor.azi(180)

sleep(1)
motor.tilt(155)

sleep(1)

while True:
    arr = sdr.sample(4096)
    print("arr", np.abs(arr.ravel()[np.abs(arr).argmax()]))
    azi_pos, tilt_pos = motor.read_pos()
    # print("azi:", azi_pos, "  tilt: ", tilt_pos)
    bf = beamforming_das(arr, 0.5, 2)  # dividing by two, due to prev test
    print("bf: ", bf)
    #motor.azi(azi_pos+bf)  # Move to biggest signal
    sleep(1)




##Div produktive funktioner:
def take_sample_and_save():
    arr = sdr.sample(4096)
    arr = arr.T

    with open('RX2_200mV_2500MHZ.txt', 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
    sdr.close()
    exit()

def plot_sample():
    import matplotlib.pyplot as plt
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