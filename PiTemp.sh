#!/bin/bash
# ram
# 3 Aug, 2020 / 17:37
# check CPU temp on a pi along with a temperature averagee of the last 24 hours
# 
# ver=0.4

while true
do
	clear
	temp=$(cat /sys/class/thermal/thermal_zone0/temp)
	cpu=$(echo "$temp / 100 * 0.1" | bc)
	cpuf=$(echo "(1.8 * $cpu) + 32" |bc)
	cpuout=$(echo $cpuf | cut -c 1-7)
	avg=$(cat pitemp.log | awk '{print $2}' >> pitemp.tmp && awk '{s+=$1}END{print "AVG:",s/NR}' pitemp.tmp)
	size=$(ls -la pitemp.log | awk '{print $5}')
	time=$($date | awk '{print $4}')
	
	echo 	
	echo "		  CPU: $cpuout F  $avg F" | tee -a pitemp.log
	echo
	max="25600"
	if [ $size -gt $max ]
	then
	tail -n -1024 pitemp.log > pitemp2.log && yes | mv pitemp2.tmp pitemp.log
	 fi
	sleep 1
done
