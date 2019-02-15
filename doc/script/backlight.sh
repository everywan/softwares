#!/bin/bash

light=$(cat /sys/class/backlight/intel_backlight/brightness)
echo $light

if [ $1 == "-inc" ]
then
	echo "inc"
	expr $2 "*" 1 &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "$(($light+$2))" | tee /sys/class/backlight/intel_backlight/brightness 
	else
		echo "plase input right arg(numbers)"
	fi
elif [ $1 == "-dec" ]
then
	echo "dec"
	expr $2 "*" 1 &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "$(($light-$2))" | tee /sys/class/backlight/intel_backlight/brightness 
	else
		echo "plase input right arg(numbers)"
	fi
else
	expr $1 "*" 1 &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "set light: $1"
		echo $1 # |tee /sys/class/backlight/intel_backlight/brightness 
	else
		echo "plase input right arg(numbers)"
	fi
fi

