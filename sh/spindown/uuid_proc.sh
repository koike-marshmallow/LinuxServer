#!/bin/bash

#configure
uuids=("13d368bf-6dbf-4751-8ba1-88bed06bef77" "")
devices=("" "mmcblk0p1")

for i in `seq 0 $((${#uuids[@]}-1))`
do
	if [ ${uuids[$i]} ]
	then
		devices[$i]=`findfs UUID="${uuids[$i]}" | sed -e "s@/dev/@@"`
	fi
done

echo "uuids : ${uuids[@]}"
echo "devices : ${devices[@]}"

for dev in ${devices[@]}
do
	newstat=`cat /proc/diskstats | grep "${dev}"`
	echo "${newstat}"
done
