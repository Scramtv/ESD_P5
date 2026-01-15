import numpy as np
import matplotlib.pyplot as plt
from sdr_ctrl import sdr_ctrl


def take_sample_and_save(sdr: sdr_ctrl, file_name: str):
    arr = sdr.sample(4096)
    save_arr(arr, file_name)
    sdr.close()
    exit()

def save_arr(arr: np.array, file_name: str):
    arr = arr.T

    with open(file_name+'.txt', 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')

def plot_sample(sdr: sdr_ctrl, samples: int = 4092):
    arr = sdr.sample(samples)
    plot(arr)
    sdr.close()
    exit()


def live_plot(sdr: sdr_ctrl):
    # Initialize the plot
    plt.ion()
    fig, (ax, ax2) = plt.subplots(2, 1, figsize=(10, 8))

    # Create initial line objects for both signals
    line1, = ax.plot([], [], 'r-', label="Channel A (Real)")
    line2, = ax.plot([], [], 'b-', label="Channel B (Real)")

    line21, = ax2.plot([], [], 'r-', label="Channel A (Real)")
    line22, = ax2.plot([], [], 'b-', label="Channel B (Real)")

    # Setup axis limits and labels
    for axs, title in zip([ax, ax2], ["Raw Data", "Normalized"]):

        axs.set_xlim(0, 1000)

        axs.set_ylim(-1, 1) # Adjust based on your SDR's gain/range

        axs.set_title(title)

        axs.grid(True)

    try:
        while True:
            # 1. Capture Data
            data = sdr.sample(1000)
            data_norm = normalize_arr(data)

            # 2. Extract Real Components
            a = data[0].real
            b = data[1].real
            x = np.arange(len(a))

            a2 = data_norm[0].real
            b2 = data_norm[1].real
            x2 = np.arange(len(a2))

            # 3. Update Line Data
            line1.set_data(x, a)
            line2.set_data(x, b)

            line21.set_data(x2, a2)
            line22.set_data(x2, b2)

            # 4. Refresh Canvas
            fig.canvas.draw()
            fig.canvas.flush_events()

    except KeyboardInterrupt:
        print("Stopped by user")
        plt.ioff()
        plt.show()


def fft(arr: list, fs:int, db:bool):
    for index, element in enumerate(arr):
        data = np.asarray(element, dtype=float)
        fft_values = np.fft.rfft(data)
        n = len(data)
        freqs = np.fft.rfftfreq(n, 1/fs)
        amplitude = np.abs(fft_values) / n
        if db:
            amplitude=20*np.log10(amplitude)

        plt.figure()
        plt.plot(freqs, amplitude)
        plt.title("Frekvensspektrum, input:"+str(index))
        plt.xlabel("Frekvens (Hz)")
        plt.ylabel("Amplitude")
    plt.show()


def plot(arr: list):
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


def load_complex_data(filename):
    data = []
    with open(filename, 'r') as file:
        for line in file:
            # Remove whitespace and skip empty lines
            line = line.strip()
            if not line:
                continue

            # Split the line into two parts at the semicolon
            parts = line.split(';')

            # Convert strings to complex numbers
            # .strip('()') removes the surrounding parentheses
            col1 = complex(parts[0].strip('()'))
            col2 = complex(parts[1].strip('()'))

            data.append([col1, col2])

    # Convert the list to a NumPy array
    return np.array(data).T


def normalize_arr(arr: np.array):
    row_min = arr.min(axis=1, keepdims=True)
    row_max = arr.max(axis=1, keepdims=True)

    arr = -1 + 2 * (arr - row_min) / (row_max - row_min)
    return arr


def offset_arr(arr: np.array, offset: int):
    arr1 = arr[0, 0:3000]
    arr2 = arr[1, offset:3000+offset]
    arr = np.array([arr1, arr2])
    return (arr)
