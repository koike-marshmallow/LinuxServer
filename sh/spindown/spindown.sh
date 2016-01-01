#!/bin/bash

#log file configure
log_file_dir="/home/owner/log/spindown/"

print_log()
{
	datestr=`date '+%y%m%d'`
	counter_log_dest="${log_file_dir}counterlog${datestr}.txt"
	datestr=`date '+%y/%m/%d %T'`
	echo "[${datestr}] $@" >> $counter_log_dest
}

#state log syntax
#<date> <time> <didx> <dname> <spin> <stat>
state_log()
{
	datestr=`date '+%y%m%d'`
	state_log_dest="${log_file_dir}statelog${datestr}-${1}.txt"
	datestr=`date '+%y/%m/%d %T'`
	echo "${datestr} $@" >> $state_log_dest
}


#######
# main

#configure
uuids=("065A38875A387591")
devices=("")
interval=60
timeout=1800

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
	sleep_time[$i]=0
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
				print_log "(${i} ${devices[$i]}) SPINDOWN: issuing standby command!"
				### ISSUING STANDBY COMMAND ###
				hdparm -y /dev/${devices[$i]} > /dev/null
				spins[$i]=0
			fi
		elif [ ${spins[$i]} -eq 0 ]
		then
			sleep_time[$i]=`expr ${sleep_time[$i]} + ${interval}`
		fi
		print_log "(${i} ${devices[$i]})   chg:NO  spin:${spins[$i]} count:${counts[$i]} sleep_time:${sleep_time[$i]}"
	else
		#IN stat changed
		if [ ${spins[$i]} -eq 0 ]
	 	then
			print_log "(${i} ${devices[$i]}) SPINUP: access detected."
		fi
		counts[$i]=${timeout}
		spins[$i]=1
		prestats[$i]=${newstat}
		print_log "(${i} ${devices[$i]})   chg:YES spin:${spins[$i]} count:${counts[$i]} sleep_time:${sleep_time[$i]}"
	fi
	state_log ${i} ${devices[$i]} ${spins[$i]} ${newstat}
done

sleep ${interval}

done
#[[master loop end]]
