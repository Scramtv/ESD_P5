import subprocess
import numpy as np
import socket
import sys
import os
import time
import matplotlib.pyplot as plt


########################################Preample########################################
# How many complex samples are wanted per iteration
Nr_Samps = 4096*160

#--- Used in steering vector ---
#Center freq
f_hi = 2.4835e9
f_lo = 2.4e9
f_c = f_lo + (f_hi - f_lo)/2
#Speed of light
c = 3e8
wavelength = c / f_c
antennas = 2
#distance between antennas
dist = wavelength / 2
#Not sure
ant_no = np.arange(antennas)


########################################Functions########################################
#Functions that sets nr of samples
def FixedNrSamps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1): # Sets a fixed sample size
        if len(chan0_data) < samps_nr:
            chan0_data = np.concatenate((chan0_data, np.frombuffer(socket_chan0.recv(), dtype=np.complex64)))
            chan0_data, chan1_data = FixedNrSamps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1)
        
        elif len(chan0_data) > samps_nr:
            chan0_data = chan0_data[:samps_nr]
        
        if len(chan1_data) < samps_nr:
             chan1_data = np.concatenate((chan1_data, np.frombuffer(socket_chan1.recv(), dtype=np.complex64)))
             chan0_data, chan1_data = FixedNrSamps(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1)
        
        elif len(chan1_data) > samps_nr:
            chan1_data = chan1_data[:samps_nr]
        
        return chan1_data, chan0_data


# Strongest frequency function
def find_freq(data, f_sample):
    fft_data = np.fft.fft(data)
    frequencies = np.fft.fftfreq(len(data), d=1 / f_sample)
    magnitude = np.abs(fft_data)
    peak_index = np.argmax(magnitude[:len(magnitude)//2])  # Ignore negative frequencies
    dominant_frequency = frequencies[peak_index]
    return dominant_frequency


########################################GNU########################################


# --- Configuration ---
# Number of bytes per complex64 value (4 bytes for I + 4 bytes for Q)
BYTES_PER_SAMPLE = np.dtype(np.complex64).itemsize 

# Total number of bytes to read per channel
BUFFER_SIZE = Nr_Samps * BYTES_PER_SAMPLE # 1024 * 8 = 8192 bytes

# --- Data Reception Function ---
def recv_data(sock):
    """
    Reads exactly BUFFER_SIZE bytes from the TCP socket, ensuring all data 
    for one chunk is received before conversion.
    """
    data = b''
    # Keep reading until we have the full BUFFER_SIZE
    while len(data) < BUFFER_SIZE:
        # Request only the remaining amount of data
        try:
            packet = sock.recv(BUFFER_SIZE - len(data))
        except socket.timeout:
            print("Warning: Socket timeout during read.")
            continue

        if not packet:
            # Connection closed by the peer (GNU Radio flowgraph stopped)
            raise ConnectionResetError("TCP Connection closed by server (GNU Radio).")
        
        data += packet
        
    # Convert raw bytes buffer into a NumPy complex array
    return np.ndarray(
        shape=Nr_Samps,
        dtype=np.complex64, 
        buffer=data
    )

# --- Data Stitching Function (Iterative, safer) ---
def Fixed_Nr_Samps_Iterative(samps_nr, chan0_data, chan1_data, socket_chan0, socket_chan1):
    # Loop to fill channel 0 data
    while len(chan0_data) < samps_nr:
        try:
            new_data = recv_data(socket_chan0)
            chan0_data = np.concatenate((chan0_data, new_data))
        except ConnectionResetError:
            # Handle flowgraph crash during iteration
            break
        
    # Trim to required size
    chan0_data = chan0_data[:samps_nr]
    
    # Loop to fill channel 1 data
    while len(chan1_data) < samps_nr:
        try:
            new_data = recv_data(socket_chan1)
            chan1_data = np.concatenate((chan1_data, new_data))
        except ConnectionResetError:
            # Handle flowgraph crash during iteration
            break
        
    # Trim to required size
    chan1_data = chan1_data[:samps_nr]
    
    return chan0_data, chan1_data

# --- Main Execution ---

# Redirect subprocess output to null to prevent "0sO" flooding
DEVNULL = open(os.devnull, 'w')
flowgraph_process = None
socket_chan0 = None
socket_chan1 = None

try:
    # 1. Start the GNU Radio program
    print("Starting GNU Radio flowgraph (Frontend.py)...")
    flowgraph_process = subprocess.Popen(["python3", "Frontend.py"], stdout=DEVNULL, stderr=DEVNULL)
    time.sleep(8) # Give the flowgraph time to start and open sockets
    
    # 2. Set up TCP sockets
    print("Connecting to TCP Sockets on ports 5000 and 5001...")

    # socket.create_connection is a robust way to connect
    socket_chan0 = socket.create_connection(("localhost", 5000))
    socket_chan1 = socket.create_connection(("localhost", 5001))
    
    # Set NO DELAY for better performance in streaming applications
    socket_chan0.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    socket_chan1.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    
    # Set a timeout in case the flowgraph stalls
    socket_chan0.settimeout(1.0)
    socket_chan1.settimeout(1.0)

    i = 0
    running=True

    # 3. Main data processing loop
    while running:

        # Pull the initial chunk of data from the sockets
        chan0_data = recv_data(socket_chan0)
        chan1_data = recv_data(socket_chan1)
        
        # Stitch collected data if initial chunks were too small
        chan0_data, chan1_data = Fixed_Nr_Samps_Iterative(
            Nr_Samps, chan0_data, chan1_data, socket_chan0, socket_chan1
        )

        with open("output.txt", "w") as f:
            for value in chan0_data:
                f.write(str(value) + "\n")


                
        # Output result
        i = i+1
        if i == 1:
            running = False


except ConnectionResetError as e:
    print(f"\nFATAL ERROR: {e}")
    print("The GNU Radio flowgraph likely crashed or terminated unexpectedly.")
    direction_of_arrival = False
    exit()

except Exception as e:
    print(f"\nAn unexpected error occurred: {e}")
    direction_of_arrival = False
    exit()

    
finally:
    print("Cleaning up resources...")
    # 4. Cleanup Subprocess
    if flowgraph_process:
        flowgraph_process.terminate()
        try:
            flowgraph_process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            flowgraph_process.kill()
            
    # 5. Cleanup Sockets
    if socket_chan0:
        socket_chan0.close()
    if socket_chan1:
        socket_chan1.close()
    
    if DEVNULL:
        DEVNULL.close()



########################################Beamforming########################################
rx = np.vstack((chan0_data, chan1_data))

doa_thetas = np.arange(-90, 90.1, 0.1) # Angular resolution of beamsteering
das_results = []
for theta in doa_thetas:
    theta_rad = np.deg2rad(theta)
    steer = np.exp(-1j * 2 * np.pi * dist * np.sin(theta_rad) * ant_no / wavelength)
    y = np.abs(np.sum(steer.conjugate().T @ rx, axis=0)) # Element wise sum
    das_results.append(np.mean(y))

das_results = np.array(das_results)
das_norm = das_results / np.max(das_results)

# Estimated AoA
direction_of_arrival = doa_thetas[np.argmax(das_results)]
print(f"Estimated DOA: {direction_of_arrival:.2f} degrees")

# Convert to dB
das_db = 20 * np.log10(np.clip(das_norm, 1e-6, None))

# Convert degrees to radians
angles_rad = np.deg2rad(doa_thetas)

'''
# Create polar plot
plt.figure(figsize=(8, 8))
ax = plt.subplot(111, polar=True)

# Plot pattern
ax.plot(angles_rad, das_db, label='Beam Pattern (dB)')
ax.plot(np.pi + angles_rad, das_db, color='gray', alpha=0.4, linestyle='--')

# Polar formatting
ax.set_theta_zero_location('N')   # Boresight
ax.set_theta_direction(-1)        # Clockwise rotation
ax.set_thetamin(-90)
ax.set_thetamax(90)
ax.set_rlabel_position(135)
ax.set_title("Beamforming Polar Response (dB Scale)", va='bottom')
ax.legend(loc='upper right')

# Radial axis in dB
ax.set_rlim(-40, 0)               # Show down to -40 dB
ax.set_rticks([-40, -30, -20, -10, 0])

plt.show()
'''