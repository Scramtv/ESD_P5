from bf import beamforming_das
from sdr_ctrl import sdr_ctrl

sdr = sdr_ctrl(40e6, 2.44175e9)

deg = -135  # Insert the phase delay here. from -180 to +180

i = 0
bfs = []  # Array for holding data
while True:
    i = i+1
    arr = sdr.sample(4)
    bf = beamforming_das(arr, 0.5, 2)
    print("bf: ", bf)  # debugging
    bfs.append(bf)

    arr = arr.T
    with open(str('BF_data_'+str(deg)+'deg'+str(i)+".txt"), 'a') as f:
        for index, item in enumerate(arr):
            f.write(str(arr[index][0])+";"+str(arr[index][1])+'\n')
    if i >= 5:
        with open('BF_results_'+str(deg)+'deg.txt', 'a') as f:
            for item in bfs:
                f.write(str(item)+'\n')
        sdr.close()
        exit()
