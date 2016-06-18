#!/bin/sh
url="http://169.254.169.254/1.0/meta-data"
declare -A CHECK
#build key/value pairs where key is meta-data url endpoint to check if it returns a naughty value
CHECK=( [hostname]=".ec2.internal" )

for I in "${!CHECK[@]}"
do
    curl -s $url/$I/ | grep -q ${CHECK[$I]} && echo "Oh no you di'int: $I of value ${CHECK[$I]} not permitted. Shutting off. Redeploy with corrected value using procedures found here: <wiki link here>"
done
#for I in "${!CHECK[@]}";do echo $I ${CHECK[$I]}; done
#curl -s http://169.254.169.254/1.0/meta-data/hostname/ | grep -q ec2.internal && echo "shutting down"
