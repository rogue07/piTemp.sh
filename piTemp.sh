#!/bin/bash
# ram
# check CPU temp on a pi for 1 minute
# ver=0.3

#log=$("count.log")
#if [ -e $log ]
#then	
#	echo
#else
#	touch $log
#fi

# hownto launch it with xurrent first


while true
do
	clear
	temp=$(cat /sys/class/thermal/thermal_zone0/temp)
	cpu=$(echo "$temp / 100 * 0.1" | bc)
	cpuf=$(echo "(1.8 * $cpu) + 32" |bc)
	cpuout=$(echo $cpuf | cut -c 1-7)
	avg=$(cat pitemp.log | awk '{print $2}' >> pitemp.tmp && awk '{s+=$1}END{print "AVG:",s/NR}' pitemp.tmp)
#	echo "at $avg >>pitemp.log"
	size=$(ls -la pitemp.log | awk '{print $5}')
	time=$($date | awk '{print $4}')

	echo 	
	echo "		  CPU: $cpuout F  $avg F" | tee -a pitemp.log
#       	echo $date >> pitemp.log
	echo
#	$size
	max="25600"
	if [ $size -gt $max ]
	then
	tail -n -1024 pitemp.log > pitemp.tmp && yes | mv pitemp.tmp pitemp.log
	 fi
	sleep 1
done
