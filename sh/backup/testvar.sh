#!/bin/sh

funca()
{
	aaa=90
	ccc="pi"
	echo $aaa $bbb $ccc
}

aaa=34
bbb="raspi"
ccc=768

echo $aaa $bbb $ccc

funca

echo $aaa $bbb $ccc

bbb="raspberry"
echo $aaa $bbb $ccc

