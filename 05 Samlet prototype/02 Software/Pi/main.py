from serial import Serial
from SerialRW.MotorComms import MotorCtrl
from bf import beamforming_das
from sdr_ctrl import sdr_ctrl
from time import sleep

from div_useful_funcs import *

sdr = sdr_ctrl(40e6, 2.44175e9) 
esp = Serial(port='/dev/ttyUSB0', baudrate=115200, timeout=1) #115200
motor = MotorCtrl(esp)

#sdr.sample(10**6)

#arr = sdr.sample(4000)
#fft(arr, 40e6, True)
#exit()
#live_plot(sdr)
#exit()

motor.tilt(165)
sleep(1)
motor.azi(180)
sleep(1)


while True:
    sleep(1) #3
    sdr.sample(10**6)
    arr = sdr.sample(100) #900
    
    #arr = normalize_arr(arr)
    azi_pos, tilt_pos = motor.read_pos() #flush buffer
    azi_pos, tilt_pos = motor.read_pos()
    print("pos: ", azi_pos)
    bf = beamforming_das(arr, 0.5, 2) 
    print("bf: ", bf, "move to: ", azi_pos+bf)
    motor.azi(azi_pos+bf)  # Move to biggest signal


while True:
    sdr.sample(10**6)
    arr = sdr.sample(100)
    print(beamforming_das(arr, 0.5, 2))
