#!/bin/bash

print_log()
{
	# configure
	log_dir="/var/log/spindown-daemon"
	log_name="spindown$(date '+%y%m%d').log"
	# prepare directory
	#if [ ! -d ${log_dir} ] ; then
	#	mkdir -p ${log_dir}
	#fi
	echo "[$(date '+%y%m%d %T')] [$1] $2"
	log_dest="${log_dir}/${log_name}"
	#echo "[$(date '+%y%m%d %T')] $@" >> ${log_dest}
}


##### HDD SPINDOWN DAEMON #####

#configure
uuids=()
devices=()
interval=5
timeout=30

# search device name
for i in `seq 0 $((${#uuids[@]}-1))`
do
	if [ ${uuids[$i]} ] ; then
		devices[$i]=`findfs UUID="${uuids[$i]}" | sed -e "s@/dev/@@"`
	fi
done

# check device name
for i in `seq 0 $((${#devices[@]}-1))`
do
	if [ -z ${devices[$i]} ] ; then
		devices[$i]="unknown"
	fi
done

# initialization message
print_log "init" "--initialization--"
print_log "init" "    uudis    : ${uuids[@]}"
print_log "init" "    devices  : ${devices[@]} (${#devices[@]})"
print_log "init" "    interval : ${interval}"
print_log "init" "    timeout  : ${timeout}"

# initialize
for i in `seq 0 $((${#devices[@]-1}))`
do
	spins[$i]=0
	prestats[$i]=""
done

# main loop
while [ true ]
do

	for i in `seq 0 $((${#devices[@]}-1))`
	do
		# check device name
		if [ ${devices[$i]} == "unknown" ] ; then
			print_log "warn" "WARN: device index [${i}] is unknown"
			continue
		fi

		# get diskstat
		newstat=`cat /proc/diskstats | grep "${devices[$i]} "`
		if [ -z "${newstat}" ] ; then
			print_log "warn" "WARN: device name [${devices[$i]} ($i)] is no stat"
			continue
		fi

		# compare diskstat
		if [ "${prestats[$i]}" == "${newstat}" ] ; then
			# in stat NO CHANGE
			if [ ${spins[$i]} -eq 1 ] ; then
				counts[$i]=`expr ${counts[$i]} - ${interval}`
				if [ ${counts[$i]} -le 0 ] ; then
					print_log "spd" "(${i} ${devices[$i]}) SPINDOWN: issuing spindown command"
					### ISSUING SPINDOWN COMMAND ###
					hdparm -y /dev/${devices[$i]} > /dev/null
					spins[$i]=0
				fi
			fi
			print_log "noc" "(${i} ${devices[$i]})    chg:NO  spin:${spins[$i]} count:${counts[$i]}"
		else
			# in stat CHAMGED
			if [ ${spins[$i]} -eq 0 ] ; then
				print_log "($i ${devices[$i]}) SPINUP: access detected."
			fi
			counts[$i]=${timeout}
			spins[$i]=1
			prestats[$i]=${newstat}
			print_log "chg" "(${i} ${devices[$i]})    chg:YES spin:${spins[$i]} count:${counts[$i]}"
		fi
		print_log "(${i} ${devices[$i]})   stat:\"${newstat}\""
	done

	sleep ${interval}

done
# main loop end
