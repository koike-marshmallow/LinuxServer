#!/bin/sh

date_str=`date '+%y%m%d'`
today_file_name="hdd_spindown${date_str}.txt"

if [ $2 ]
then
	select_file=$2
else
	select_file=$today_file_name
fi

if [ $1 ]
then
	case $1 in
	"follow" )
		tail -f $today_file_name
	;;
	"chkspin" )
		grep -E "(SPINUP|SPINDOWN|initialization)" $select_file
	;;
	"statechg" )
		grep "chg:YES" $select_file
	;;
	"cspinup" )
		if [ $select_file = "all" ]
		then
			cat hdd_spindown*.txt | grep "SPINUP" | wc -l
		else
			grep "SPINUP" $select_file | wc -l
		fi
	;;
	* )
		echo "未定義のコマンド: $1"
	;;
	esac
else
	tail $today_file_name
fi
