#!/bin/bash

print_log()
{
	datestr=`date '+%y%m%d'`
	file_dest="/home/pi/log/hdd_spindown${datestr}.txt"
	datestr=`date '+%y/%m/%d %T'`
	#echo "[${datestr}] $@"
	echo "[${datestr}] $@" >> ${file_dest}
}


#######
# main

#configure
uuids=("065A38875A387591")
devices=("")
interval=5
timeout=30

#get device name
for i in `seq 0 $((${#uuids[@]}-1))`
do
	if [ ${uuids[$i]} ]
	then
		devices[$i]=`findfs UUID="${uuids[$i]}" | sed -e "s@/dev/@@"`
	fi
done

#check device name
for i in `seq 0 $((${#devices[@]}-1))`
do
	if [ -z ${devices[$i]} ]
	then
		devices[$i]="unknown"
	fi
done

print_log "-- initialization --"
print_log "    uuids    : ${uuids[@]}"
print_log "    devices  : ${devices[@]} (${#devices[@]})"
print_log "    interval : ${interval}"
print_log "    timeout  : ${timeout}"


#initialize
for i in `seq 0 $((${#devices[@]}-1))`
do	spins[$i]=0
	prestats[$i]=""
done


#[[master loop]]
while [ true ]
do

for i in `seq 0 $((${#devices[@]}-1))`
do

	#check unknown device name
	if [ ${devices[$i]} == "unknown" ]
	then
		print_log "WARN: device index [${i}] is unknown"
		continue
	fi

	#get diskstat
	newstat=`cat /proc/diskstats | grep "${devices[$i]} "`

	#check get diskstat
	if [ -z "${newstat}" ]
	then
		print_log "WARN: device name [${devices[$i]} (${i})] is no stat data"
		continue
	fi

	#compare new/pre diskstat
	if [ "${prestats[$i]}" == "${newstat}" ]
	then
		#IN stat no change
		if [ ${spins[$i]} -eq 1 ]
		then
			counts[$i]=`expr ${counts[$i]} - ${interval}`
			if [ ${counts[$i]} -le 0 ]
			then
				print_log "INFO: device \"${devices[$i]}\" SPINDOWN!"
				### ISSUING STANDBY COMMAND ###
				hdparm -y /dev/${devices[$i]} > /dev/null
				spins[$i]=0
			fi
		fi
		print_log "(${i} ${devices[$i]}) chg:NO  spin:${spins[$i]} count:${counts[$i]} stat:\"${newstat}\""
	else
		#IN stat changed
		if [ ${spins[$i]} -eq 0 ]
		then
			print_log "INFO: device \"${devices[$i]}\" SPINUP!"
		fi
		counts[$i]=${timeout}
		spins[$i]=1
		prestats[$i]=${newstat}
		print_log "(${i} ${devices[$i]}) chg:YES spin:${spins[$i]} count:${counts[$i]} stat:\"${newstat}\""
	fi
done

sleep ${interval}

done
#[[master loop end]]
