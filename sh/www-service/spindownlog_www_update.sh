#!/bin/sh

#configure
dest_file="spindownlog_latest.txt"
copy_rows_count=3
interval=2
buffer_file="/var/tmp/spindownlog_tmp.txt"


#set log file path
datestr=`date '+%y%m%d'`
log_file_dir="/home/ubuntu/log/spindown/"
log_file_path="${log_file_dir}hdd_spindown${datestr}.txt"


#prepare destination file
if [ ! -f $dest_file ]
then
	touch $dest_file
	echo "create dest file"
fi


#main loop
while [ true ]
do
	tail -n $copy_rows_count $log_file_path >> $dest_file
	tail -n $copy_rows_count $dest_file > $buffer_file
	cp $buffer_file $dest_file
	rm $buffer_file

	timestamp=`date`
	echo "( last modified: ${timestamp} )" >> $dest_file
	echo "-------------------------------" >> $dest_file

	sleep $interval
done


