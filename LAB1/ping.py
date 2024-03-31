#!/usr/bin/env python3

import multiprocessing
from pythonping import ping
import time
import pickle

def function(server, name, delays, throughputs, times):
    delay = []
    throughput = []
    timestamps = []

    for i in range(100):
        start = time.time()
        timestamps.append(start)
        ping_output = ping(str(server), verbose=True, count=30, size=100)

        end = time.time()
        avg_delay = ping_output.rtt_avg_ms
        valid_cnt = 30 - ping_output.packets_lost
        thru_put = (valid_cnt * 128) / (end - start)

        delay.append(end - start)
        throughput.append(thru_put)
        time.sleep(15)

    delays.append(delay)
    throughputs.append(throughput)
    times.append(timestamps)

if __name__ == '__main__':
    manager = multiprocessing.Manager()
    Delays = manager.list()
    Throughputs = manager.list()
    Times = manager.list()

    Names = ["Gateway Router", "Bell Teleservices India Pvt. Ltd.", "Google LLC California"]
    servers = ["172.16.22.1", "203.201.60.12", "8.8.8.8"]

    processes = []

    for i in range(3):
        process = multiprocessing.Process(
            target=function,
            args=(servers[i], Names[i], Delays, Throughputs, Times)
        )
        processes.append(process)
        process.start()

    for process in processes:
        process.join()

    # Load the data later on to process
    data = {'Names': Names, 'Servers': servers, 'Times': list(Times), 'Delays': list(Delays), 'Throughputs': list(Throughputs)}
    with open('ping_data_new.pkl', 'wb') as file:
        pickle.dump(data, file)


# open this 