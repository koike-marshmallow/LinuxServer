#!/bin/sh

ecfunc()
{
	echo $str
	echo "args = $@"
}

str="success"

echo "----_"
ecfunc
