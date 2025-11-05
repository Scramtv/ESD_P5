#Imports
import subprocess
import numpy as np
import zmq

#How many samples there is wanted
Nr_Samps = 1

#Fuctionschan0_data, chan1_data =
def Fixed_Nr_Samps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1): # Sets a fixed sample size
        if len(chan0_data) < samps_nr:
            chan0_data = np.concatenate((chan0_data, np.frombuffer(socket_chan0.recv(), dtype=np.complex64)))
            chan0_data, chan1_data = Fixed_Nr_Samps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1)
        
        elif len(chan0_data) > samps_nr:
            chan0_data = chan0_data[:samps_nr]
        
        if len(chan1_data) < samps_nr:
             chan1_data = np.concatenate((chan1_data, np.frombuffer(socket_chan1.recv(), dtype=np.complex64)))
             chan0_data, chan1_data = Fixed_Nr_Samps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1)
        
        elif len(chan1_data) > samps_nr:
            chan1_data = chan1_data[:samps_nr]
        
        return chan1_data, chan0_data





#Starts the GNU program
flowgraph_process = subprocess.Popen(["python3", "Frontend.py"])

#Sets up sits where the data from GNU is pushed
context = zmq.Context()
socket_chan0 = context.socket(zmq.SUB)
socket_chan0.connect("tcp://localhost:5555")
socket_chan0.setsockopt_string(zmq.SUBSCRIBE, '')
socket_chan1 = context.socket(zmq.SUB)
socket_chan1.connect("tcp://localhost:5556")
socket_chan1.setsockopt_string(zmq.SUBSCRIBE, '')



#Main program
try:
    while True: #Runs until ctrl + c, is pressed while in the terminal
        #Pull data from the sits
        chan0_data = np.frombuffer(socket_chan0.recv(), dtype=np.complex64)
        chan1_data = np.frombuffer(socket_chan1.recv(), dtype=np.complex64)
        #print(len(chan0_data))
        
        #Sets the number of samples
        chan0_data, chan1_data = Fixed_Nr_Samps(Nr_Samps, chan0_data, chan1_data, socket_chan0, socket_chan1)
        
        #Converts the data to floating points, from binary complex 64
        

        #prints the converted data
        print("Chan 0 Data:", chan0_data, "Nr. Sampls", len(chan0_data))
        print("Chan 1 Data:", chan1_data, "Nr. Sampls", len(chan1_data))

except KeyboardInterrupt: # what to do when interupted
    print("Stopping...")

finally: #Terminates the GNU radio program
    flowgraph_process.terminate()
    flowgraph_process.wait()
    exit()