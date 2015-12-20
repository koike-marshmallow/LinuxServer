#!/bin/bash

datestr=`date '+%y%m%d%H%M%S'`
log_file_dest="/home/owner/log/backup/backup${datestr}.txt"

##logger
print_log()
{
	echo $@ >> $log_file_dest
}


##configuation
backup_dest=/mnt/nas_hdd1/NAS_BACKUP/  #スラッシュをつけること
sources=(/mnt/nas_hdd1/test /mnt/nas_usm1)


##mainscript

datestr=`date '+%c'`

print_log "--------------------"
print_log "--------------------"
print_log "BACKUP PROCESS START (${datestr})"
print_log "backup_dest: ${backup_dest}"
print_log "sources: ${sources[@]}"


for src in ${sources[@]}
do
	if [ "$1" = "run" ]
	then
		print_log ""
		print_log "---------------"
		print_log "----- start backup \"${src}\""
		rsync $src $backup_dest -av --delete >> $log_file_dest 2>&1
	else
		print_log ""
		print_log "---------------"
		print_log "----- backup dry run \"${src}\""
		rsync $src $backup_dest -avn --delete >> $log_file_dest 2>&1
	fi
done

print_log ""
print_log "--------------"
print_log "----- backup complete."

datestr=`date '+%c'`
print_log "BACKUP PROCESS END (${datestr})"
