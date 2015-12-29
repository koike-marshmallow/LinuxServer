#!/bin/sh

#configure
dest_file="/var/www/html/spindownlog_latest.html"
copy_rows_count=30


#set log file path
datestr=`date '+%y%m%d'`
log_file_dir="/home/ubuntu/log/spindown/"
log_file_path="${log_file_dir}hdd_spindown${datestr}.txt"


#prepare destination file
: > $dest_file

#write html header
echo "<html>" >> $dest_file
echo "<head><meta charset=\"utf-8\"/></head>" >> $dest_file

#write log record(body)
echo "<body><pre><code>" >> $dest_file

echo "FILE NAME: ${log_file_path}" >> $dest_file
echo "UPDATE TIME: " `date` >> $dest_file
echo "------------------------------" >> $dest_file

tail -n $copy_rows_count $log_file_path >> $dest_file

echo "</code></pre></body>" >> $dest_file

#write html footer
echo "</html>" >> $dest_file
