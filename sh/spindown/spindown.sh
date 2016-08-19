#!/bin/bash

### Configuration ###
UUIDS=()
DEVICES=()
INTERVAL=60
TIMEOUT=3600

LOG_DIR="logs"
LOG_LEVEL=1

write_log()
{
  # configure
  log_dir=${LOG_DIR}
  log_name="noname"
  filename_auto_complete="enabled"
  date_auto_complete="enabled"
  # filename auto complete
  if [ $# -gt 1 -a $filename_auto_complete = "enabled" ] ; then
    log_name=$1 ; shift
  fi
  # prepare directory
  if [ ! -d ${log_dir} ] ; then
    mkdir -p ${log_dir}
  fi
  # output
  if [ $date_auto_complete = "enabled" ] ; then
    log_dest="${log_dir}/${log_name}$(date '+%y%m%d').log"
  else
    log_dest="${log_dir}/${log_name}.log"
  fi
  #echo "${log_dest}> [$(date '+%y%m%d %T')] $@"
  echo "[$(date '+%y/%m/%d %T')] $@" >> ${log_dest}
}

write_log_leveling()
{
  # configure
  log_level=${LOG_LEVEL}
  # argument check
  expr $1 + 1 > /dev/null 2>&1
  if [ $? -lt 2 ] ; then
    #logging
    if [ $1 -ge ${log_level} ] ; then
      shift
      write_log $@
    fi
  fi
}

log()
{
  scode=$1
  shift
  case ${scode} in
    "WARN" ) write_log_leveling 4 "spindown" "WARN" $@ ;;
    "INIT" ) write_log_leveling 3 "spindown" "INIT" $@ ;;
    "NOTC" ) write_log_leveling 3 "spindown" "NOTICE" $@ ;;
    "INFO" ) write_log_leveling 2 "spindown" "INFO" $@ ;;
    "CNT"  ) write_log_leveling 1 "spindown" "COUNT" $@ ;;
    "STAT" ) write_log_leveling 0 "stats" $@ ;;
  esac
}


##### HDD SPINDOWN DAEMON #####

# initialization message
log "INIT" "-- hdd spindown daemon initilazed!! --"
log "INIT" "interval value: ${INTERVAL}"
log "INIT" "timeout value: ${TIMEOUT}"
log "INFO" "uuid configurations: ${UUIDS[@]} (${#UUIDS[@]})"
log "INFO" "device configurations: ${DEVICES[@]} (${#DEVICES[@]})"


# cofigure device name
for i in `seq 0 $((${#DEVICES[@]}-1))`
do
  if [ ${UUIDS[$i]} ] ; then
    DEVICES[$i]=`findfs UUID="${UUIDS[$i]}" | sed -e "s@/dev/@@"`
    log "INIT" "configured device (device id: ${i})\"${DEVICES[$i]}\" by uuid ${UUIDS[$i]}"
  fi
  if [ -z ${DEVICES[$i]} ] ; then
    DEVICES[$i]="unknown"
    log "WARN" "device configure is failed ID:${i} UUID:${UUIDS[$i]}"
  fi
done
log "INIT" "devices configured: ${DEVICES[@]} (${#DEVICES[@]} device(s))"

# initialize
for i in `seq 0 $((${#DEVICES[@]-1}))`
do
	spins[$i]=0
	prestats[$i]=""
done

# main loop
while [ true ]
do

	for i in `seq 0 $((${#DEVICES[@]}-1))`
	do
		# check device name
		if [ ${DEVICES[$i]} == "unknown" ] ; then
			continue
		fi

		# get diskstat
		newstat=`cat /proc/diskstats | grep "${DEVICES[$i]} "`
    log "STAT" ${DEVICES[$i]} ${newstat}
		if [ -z "${newstat}" ] ; then
			log "WARN" "diskstat empty ID:${i} DEVICE:${DEVICES[$i]}"
			continue
		fi

		# compare diskstat
		if [ "${prestats[$i]}" == "${newstat}" ] ; then
			# in stat NO CHANGE
			if [ ${spins[$i]} -eq 1 ] ; then
				counts[$i]=`expr ${counts[$i]} - ${INTERVAL}`
				if [ ${counts[$i]} -le 0 ] ; then
          log "NOTC" "ID:${i} DEVICE:${DEVICES[$i]} SPINDOWN issuing standby command."
					### ISSUING SPINDOWN COMMAND ###
					hdparm -y /dev/${DEVICES[$i]} > /dev/null
					spins[$i]=0
				fi
			fi
      log "CNT" "#${i} ${DEVICES[$i]} 0 ${spins[$i]} ${counts[$i]}"
		else
			# in stat CHAMGED
			if [ ${spins[$i]} -eq 0 ] ; then
        log "NOTC" "ID:${i} DEVICE:${DEVICES[i]} SPINUP access detected."
			fi
			counts[$i]=${TIMEOUT}
			spins[$i]=1
			prestats[$i]=${newstat}
      log "CNT" "#${i} ${DEVICES[$i]} 1 ${spins[$i]} ${counts[$i]}"
		fi
	done

	sleep ${INTERVAL}

done
# main loop end
