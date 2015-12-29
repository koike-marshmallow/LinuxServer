#!/bin/sh

#configure
dest_file="/var/www/html/spindownlog_latest.txt"
copy_rows_count=30


#set log file path
datestr=`date '+%y%m%d'`
log_file_dir="/home/ubuntu/log/spindown/"
log_file_path="${log_file_dir}hdd_spindown${datestr}.txt"


#prepare destination file
if [ ! -f $dest_file ]
then
	touch $dest_file
fi


#write copy log file
echo "FILE NAME: ${log_file_path}" > $dest_file
echo "UPDATE TIME: " `date` >> $dest_file
echo "------------------------------" >> $dest_file

tail -n $copy_rows_count $log_file_path >> $dest_file
