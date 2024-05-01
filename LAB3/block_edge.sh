#!/bin/bash

#add packet loss
ip netns exec AC tc qdisc add dev ac root netem loss 100%

# Wait for 30 seconds
sleep 30

#delete packet loss
ip netns exec AC tc qdisc del dev ac root
