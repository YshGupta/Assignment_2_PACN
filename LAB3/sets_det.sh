#!/bin/bash

# The links
links=("D A" "A C" "B C" "A B" "C D")

# IP addresses
ip_adr=("192.0.2.2 192.0.2.7" "192.0.2.1 192.0.2.5" "192.0.2.8 192.0.2.3" "192.0.2.4 192.0.2.7" "192.0.2.6 192.0.2.9 " )

declare -A map

map[AC]=0
map[AB]=1
map[BC]=3
map[CD]=4
map[DA]=2

get_ip() {
    local element="$1"
    local index="${map[$element]}"
    echo "${ip_adr[$index]}"
}

execute_command() {
    local source="$1"
    local destination="$2"
    combined="${source}${destination}"
    local ip="$(get_ip "$combined")"
    local namespace="$combined"

    local command="sudo ip netns exec $namespace timeout 4s ping -I $ip"

    # echo -e "\e[1;92m$command activated\e[0m" | awk '{printf "%-70s %s\n", $0, ""}'
    $command
}

execute_set() {
    local set=("$@")
    for link in $set; do
        source="${link:0:1}"
        destination="${link:1:1}"
        # Note that there might not be a visually appealing output because of the awkard spaces in ping response , occuring because of the simultaneous output of processes.
        # to see a pretty output use this command  instead - ` execute_command "$source" "$destination" | awk '{printf "%-70s %s\n", $0, ""}' `  
        execute_command "$source" "$destination"  &
    done
    wait  # Wait for all background processes to finish
}

tdma() {
    local sets=(set1 set2 set3)  
    local total_sets=${#sets[@]}

    local current_set_index=0
    local max_cycles=9
    local cycle_count=0

    while [ "$cycle_count" -lt "$max_cycles" ]; do
        # echo 
        # echo 
        # echo 
        # echo -e "\e[1;92m${sets[current_set_index]} activated\e[0m" | awk '{printf "%-70s %s\n", $0, ""}'
        execute_set "${!sets[current_set_index]}"  # Execute commands for the current set
        current_set_index=$(( (current_set_index + 1) % total_sets ))  # Move to the next set cyclically
        ((cycle_count++))
        # echo
    done
}

#  sets
set1=("AB CD")
set2=("BC DA")
set3=("AC")

tdma

