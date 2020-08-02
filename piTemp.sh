#!/bin/bash
# ram
# check CPU temp on a pi for 1 minute
# ver 1.0

for ((i=0; i<60; i++))
do
	clear
	cpu=$(cat /sys/class/thermal/thermal_zone0/temp)
	cpuf=$(echo "$cpu/555.55" | bc -l)
	cpuout=$(echo $cpuf | cut -c 1-7)
	minute=$(cat temppi.log | grep F | tail -n 10 | awk '{print $2}' | paste -sd+ - | bc | cut -c 1-4)
	lines=$(cat temppi.log | wc -l)
	avg=$(echo "$minute/10" | bc -l | cut -c 1-7)
	echo "$(date)" | tee -a temppi.log
	echo "--------------------------------------"
	echo "CPU: $cpuout F  AVG: $avg F" | tee -a temppi.log
	sleep 1
	if [ $i == 59 ]
	then
		exit
	else
		echo "$i"
	fi
	
		
done
