#!/bin/sh

#configure
interval=60

#main loop
while [ true ]
do
	#update hddspindown log
	/usr/local/bin/update_spindownlog.sh

	sleep $interval
done
