#!/bin/bash

#echo date
echo "-----"
echo "excute daily script(" `date` ")"

#backup nas
/usr/local/bin/backup.sh run

#reboot system
sync
shutdown -r +3 "system will reboot, this is daily exec"
