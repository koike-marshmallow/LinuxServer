#!/bin/sh

dest_file="/var/www/html/hdd_size_info.txt"
html_dest_file="/var/www/html/hdd_size_info.html"

: > $dest_file

echo "[nas_hdd1_root]" >> $dest_file
du -s /mnt/nas_hdd1/* | sort -n >> $dest_file

echo "(last modified " `date` " )" >>$dest_file
echo "---------------------------" >>$dest_file

/usr/local/bin/htmlconvert.sh $dest_file $html_dest_file
