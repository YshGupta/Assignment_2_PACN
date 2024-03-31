#!/bin/bash

# Variables
file_sizes=("10KB" "1MB" "100MB")
download_speeds=("5M" "100M")
concurrent_downloads=(1 2 3)
time_of_day="Evening"
urls=("https://cloud.iitmandi.ac.in/f/f2136456bcf6439eaf18/?dl=1" "https://cloud.iitmandi.ac.in/f/dcd4883d914a44fb9850/?dl=1" "https://cloud.iitmandi.ac.in/f/4b2c32ec021e4de4a710/?dl=1")
# Output file
output_file="output.txt"
reps=3
echo "file_size | download_speed | num_downloads | time_of_day | throughput" > "$output_file"


# Iterate through file sizes
for ((i=0; i<${#file_sizes[@]}; i++)); do
    file_size="${file_sizes[$i]}"
    url="${urls[$i]}"

    # Iterate through number of concurrent downloads
    for num_downloads in "${concurrent_downloads[@]}"; do

        # Iterate through download speeds
        for speed in "${download_speeds[@]}"; do
	
		for ((rep=1; rep<=$reps; rep++)); do

                	throughputs=()
                	pids=()
                	for ((j=0; j<num_downloads; j++)); do
                        	wget_output=$(wget --limit-rate="$speed" "${urls[$i]}" 2>&1 &)
		       		temp_pid=$!
                        	pids+=($temp_pid)
                        	temp_throughput=$(echo "$wget_output" | grep -o '[0-9.]\+\s*[KMGTPE]B/s')
                        	throughputs+=("$temp_throughput")
               	 	done

                	for pid in "${pids[@]}"; do
                        	wait "$pid"
                	done

                	# Calculate total throughput
                	total_throughput=0
                	for throughput in "${throughputs[@]}"; do
                        	numerical_value=$(echo "$throughput" | grep -o '[0-9.]\+')
                        	unit=$(echo "$throughput" | grep -o '[KMGTPE]B/s')
                        	case $unit in
                            		"KB/s") total_throughput=$(bc <<< "$total_throughput + $numerical_value");;
                            		"MB/s") total_throughput=$(bc <<< "$total_throughput + $numerical_value * 1024");;
                            		"GB/s") total_throughput=$(bc <<< "$total_throughput + $numerical_value * 1024 * 1024");;
                            		# Add cases for other units as needed
                       	 	esac
                	done
		
			#$total_throughput /= $num_downloads
			total_throughput=$(bc <<< "scale=2; $total_throughput / $num_downloads")

                	# Print tabulated results to output file
               	 	echo "$file_size | $speed | $num_downloads | $time_of_day | $total_throughput" >> "$output_file"
		done
	done
    done
done


rm index.html\?dl\=1*
