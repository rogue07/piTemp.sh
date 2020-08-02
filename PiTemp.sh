#!/bin/bash
# ram
# check CPU temp on a pi for 1 minute
# ver=0.3

while true
do
	clear
	temp=$(cat /sys/class/thermal/thermal_zone0/temp)
	cpu=$(echo "$temp / 100 * 0.1" | bc)
	cpuf=$(echo "(1.8 * $cpu) + 32" |bc)
	cpuout=$(echo $cpuf | cut -c 1-7)
	minute=$(cat temppi.log | grep F | tail -n 60 | awk '{print $2}' | paste -sd+ - | bc | cut -c 1-4)
	lines=$(cat temppi.log | wc -l)
	avg=$(echo "$minute/60" | bc -l | cut -c 1-7)
	

	echo "$(date)" | tee -a temppi.log
	echo "================================="
	echo "CPU: $cpuout F  AVG: $avg F" | tee -a temppi.log
	echo

	size=$(ls -la temppi.log | awk '{print $5}')
	max="35000"
	if [ $size -gt $max ]
	then
		tail -n -600 temppi.log > temppi.tmp && yes | mv temppi.tmp temppi.log
	fi
	sleep 1
done
