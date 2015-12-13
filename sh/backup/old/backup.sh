#!/bin/bash

##configuation
backup_dest=/home/pi/backup/  #スラッシュをつけること
sources=(~/test/dir1)


##mainscript

datestr=`date '+%y%m%d%H%M%S'`
log_file_dest="/home/pi/log/backup${datestr}.txt"
datestr=`date '+%c'`

echo "--------------------" >> $log_file_dest
echo "--------------------" >> $log_file_dest
echo "BACKUP PROCESS START (${datestr})" >> $log_file_dest
echo "backup_dest: ${backup_dest}" >> $log_file_dest
echo "sources: ${sources[@]}" >> $log_file_dest


for src in ${sources[@]}
do
	echo "----- start backup \"${src}\"" >> $log_file_dest
	rsync $src $backup_dest -av --delete >> $log_file_dest
done

echo "----- backup complete." >> $log_file_dest
