#!/bin/bash

# The links
links=("D A" "A C" "B C" "A B" "C D")

#IP addresses
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
      

    local command="sudo ip netns exec $namespace  timeout 4s  ping -I $ip"

    echo "$command"
    $command   
}


fn(){
      # Select a random link
    random_index=$(( RANDOM % ${#links[@]} ))
    random_link="${links[$random_index]}"
    source="${random_link%% *}"
    destination="${random_link#* }"
    echo "Selected link: $source to $destination"
    execute_command "$source" "$destination"
}

# Main function
main() {
    for ((i=1; i<=9; i++)); do
        echo 
        fn
    done
}

main

