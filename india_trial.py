#!/usr/bin/env python3

import multiprocessing
from pythonping import ping
import time
import pickle
import matplotlib.pyplot as plt


if __name__ == '__main__':

    delay = []
    throughput = []

    for i in range(100):
        start = time.time()
        ping_output = ping(str("203.201.60.12"), verbose=True, count=30, size=100)

        end = time.time()
        avg_delay = ping_output.rtt_avg_ms
        valid_cnt = 30 - ping_output.packets_lost
        thru_put = (valid_cnt * 128) / (end - start)

        delay.append(end - start)
        throughput.append(thru_put)
        time.sleep(1)

    plt.scatter(throughput , delay , marker = 'o' , color = 'b')

    # plt.plot(sorted_throughputs_i , sorted_delays_i , color = 'r')
    plt.show()