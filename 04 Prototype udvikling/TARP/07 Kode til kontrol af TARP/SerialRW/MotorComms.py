from serial import Serial
from SerialRW import serial_read, serial_write

class MotorCtrl:
    def __init__(self, serial_inst: Serial):
        self.serial_inst = serial_inst

    def tilt(self, degrees: float|int) -> None:
        """ Controls tilt motor
        args:
            degrees (float|int): degrees in which tilt motor should move to
        returns:
            None
        """
        self.__motor_cmd(True, degrees)
    
    def azi(self, degrees: float|int) -> None:
        """
        Controls Azimuth motor
        args:
            degrees (float|int): degrees in which azimuth motor should move to
        returns:
            None
        """
        self.__motor_cmd(False, degrees)

    def __motor_cmd(self, motor:bool, degrees: float|int) -> None:
        """ Commands a motor, to move to a certain angle
        args:
            motor (bool): If true -> tilt, if false -> Azi
            degrees (float|int): degrees in which the motor should move to
        returns:
            None
        """
        while degrees>360:
            degrees-=360
        while degrees<0:
            degrees+=360

        if not isinstance(motor, bool):
            raise ValueError("Motor must bool")
        
        if isinstance(degrees, (int, float)):
            degrees = round(degrees, 1)
            degrees*=10 #For transfere, degrees are multiplied by 10, then divided again on the ESP
            package = self.__build_motor_packet(motor, int(degrees))
            serial_write(self.serial_inst, package)
        else:
            raise ValueError("MotorCtrl expects int or float")
        
    def __build_motor_packet(self, motor: bool, degrees: int) -> bytes:
        """ Builds the serial package for controlling a motor
        args:
            motor (bool): If true -> tilt, if false -> Azi
            degrees (float|int): degrees in which the motor should move to
        returns:
            serial package (bytes): Serial package to send to ESP
        """
        if not isinstance(motor, bool):
            raise ValueError("Motor must be bool")
        if not isinstance(degrees, int) or not (0 <= degrees <= 3600):
            raise ValueError("Degrees must be an integer between 0 and 3600")

        # Bit packing: [motor(1)][degrees(12)][unused(3)=0] -> 16 in total
        motor_bit = motor
        degrees_bits = degrees & 0xFFF  # Forces to only keep 12 bits (0xFFF is just to tell python this)

        packed = (motor_bit << 15) | (degrees_bits << 3)#Shifts motor_bit to MSB, and shifts degrees 3 to have 3 zeros in the end

        # Convert to bytes
        b1 = (packed >> 8) & 0xFF #Bit 1 containing the MSB part of package
        b2 = packed & 0xFF #Bit 2 containing the LSB part of package

        result = bytes([b1, b2, ord(';')])
        return result


    def read_pos(self) -> tuple:
        """ Reads position of azimuth and tilt motor.
        args:
            None
        returns:
            pos (tuple): Containing azimuth position, tilt position
        """
        self.serial_inst.reset_input_buffer()
        serial_read(self.serial_inst, timeout=0.2) #Discarding uncomplete data
        data = serial_read(self.serial_inst, timeout=0.2)

        azi, tilt = data.split(";")

        return(float(azi), float(tilt))


#EXAMPLE USAGE
if __name__ == "__main__":
    esp = Serial(port='/dev/ttyUSB0',baudrate=115200,timeout=1)
    motor_ctrl = MotorCtrl(esp)
    motor_ctrl.tilt(370)
    motor_ctrl.read_pos()
