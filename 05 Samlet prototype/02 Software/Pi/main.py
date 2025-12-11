from serial import Serial
from SerialRW.MotorComms import MotorCtrl
from bf import beamforming_das
from sdr_ctrl import sdr_ctrl
from time import sleep

sdr = sdr_ctrl(40e6, 2.44175e9) 
esp = Serial(port='/dev/ttyUSB0', baudrate=115200, timeout=1)
motor = MotorCtrl(esp)


motor.azi(180)
sleep(1)
motor.tilt(155)
sleep(1)

while True:
    arr = sdr.sample(4)
    azi_pos, tilt_pos = motor.read_pos()
    bf = beamforming_das(arr, 0.5, 2) 
    print("bf: ", bf)
    motor.azi(azi_pos+bf)  # Move to biggest signal
