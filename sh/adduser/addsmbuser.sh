#!/bin/bash

user_dir_root="/mnt/nas_hdd1/SAMBA_HOMES/"

#check argument and set parameter
if [ ! "$1" ] 
then
	echo "ユーザ名を指定して下さい"
	exit
fi

user_name=$1
user_dir="${user_dir_root}${user_name}"

#add linux user
echo "linuxユーザを追加します"
adduser $user_name -s /dev/false

#add samba user
echo "sambaユーザを追加します"
echo "パスワードを入力して下さい"
pdbedit -a -u $user_name

#create user directory
if [ ! -d $user_dir ] then
	mkdir $user_dir
	echo "${user_dir}を作成しました"
fi
