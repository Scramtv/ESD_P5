Main:
from serial import Serial
from SerialRW.MotorComms import MotorCtrl
from bf import beamforming_das
from sdr_ctrl import sdr_ctrl
from time import sleep, time

sdr = sdr_ctrl(40e6, 2.44175e9)
esp = Serial(port='/dev/ttyUSB0', baudrate=115200, timeout=1)
motor = MotorCtrl(esp)

for _ in range(0,5):
    motor.azi(180)
    sleep(1)
    motor.tilt(155)
    sleep(1)

    t0 = time()
    motor.azi(180-120)
    sleep(3)#wait until azi is stable
    arr = sdr.sample(900)
    beamforming_das(arr, 0.5, 2)
    print(time()-t0)
sdr.close()