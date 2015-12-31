#!/bin/sh

#configure
dest_file="/var/www/html/spindownlog_latest.txt"
html_dest_file="/var/www/html/spindownlog_latest.html"
copy_rows_count=30


#set log file path
datestr=`date '+%y%m%d'`
log_file_dir="/home/ubuntu/log/spindown/"
log_file_path="${log_file_dir}hdd_spindown${datestr}.txt"


#prepare destination file
: > $dest_file

#write header
echo "FILE NAME: ${log_file_path}" >> $dest_file
echo "UPDATE TIME: " `date` >> $dest_file

#write chkspin log
echo "------------------------------" >> $dest_file
echo "- CHKSPIN -" >> $dest_file
grep -E "(SPINUP|SPINDOWN|initialization)" $log_file_path >> $dest_file

#write recent log
echo "------------------------------" >> $dest_file
echo "- RECENT LOG -" >> $dest_file
tail -n $copy_rows_count $log_file_path >> $dest_file

#convert to html
/usr/local/bin/htmlconvert.sh $dest_file $html_dest_file
