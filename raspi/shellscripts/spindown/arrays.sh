#!/bin/bash

array=("zero" "one" "two" "three" "four")
sequence=`seq 0 $((${#array[@]}-1))`

for i in ${sequence}
do
	echo ${i}番目 ${array[$i]}
done
