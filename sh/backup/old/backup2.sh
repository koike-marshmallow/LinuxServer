#!/bin/bash


##configuation
backup_dest=/mnt/nas_hdd1/NAS_BACKUP/  #スラッシュをつけること
sources=(/mnt/nas_hdd1/SAMBA_HOMES/pi /home/samba/public)


##mainscript

datestr=`date '+%y%m%d%H%M%S'`
log_file_dest="/home/pi/log/backup/backup${datestr}.txt"
datestr=`date '+%c'`

echo "--------------------" >> $log_file_dest
echo "--------------------" >> $log_file_dest
echo "BACKUP PROCESS START (${datestr})" >> $log_file_dest
echo "backup_dest: ${backup_dest}" >> $log_file_dest
echo "sources: ${sources[@]}" >> $log_file_dest


for src in ${sources[@]}
do
	if [ $1 = "run" ]
	then
		echo "----- start backup \"${src}\"" >> $log_file_dest
		rsync $src $backup_dest -av --delete >> $log_file_dest
	else
		echo "----- backup dry run \"${src}\"" >> $log_file_dest
		rsync $src $backup_dest -avn --delete >> $log_file_dest
	fi
done

echo "----- backup complete." >> $log_file_dest
