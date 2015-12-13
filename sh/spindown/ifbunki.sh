#!/bin/bash

str=""

echo ${str}
echo "length = ${#str}"

if [ -n ${str} ] 
then
	echo "分岐1だぜ"
	echo "分岐1やで"
else
	echo "文字列入れろや"
	echo "分岐2だよ"
fi
