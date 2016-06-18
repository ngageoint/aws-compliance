#!/bin/sh
url="http://169.254.169.254/1.0/meta-data"
message="Oh No You Di'int. Shutting off so you can redeploy with corrected value using procedures found here: <wiki link here>"
declare -A CHECK
#build key/value pairs where key is meta-data url endpoint to check if it returns a good value
#                   desired domain                desired key
CHECK=( [hostname]=".ec2.internal" [public-keys]="fitz-pass" [security-groups]="ssh-from-home","test" )

for I in "${!CHECK[@]}"
do
    for J in $(echo "${CHECK[$I]}" | sed "s/,/ /g")
    do
        echo "      Error: $I of value $J not permitted." &&\
        echo "             $message" &&\
        logger "Error: $I of value $J not permitted." $message #&& sudo poweroff
    done
    #curl -s $url/$I/ | grep -q ${CHECK[$I]} ||  echo "Error: $I of value ${CHECK[$I]} not permitted. $message" #&& sudo poweroff
    #curl -s $url/$I/ | grep -q ${CHECK[$I]} && echo "Error: $I of value ${CHECK[$I]} not permitted. $message" #&& sudo poweroff
done
#curl -s http://169.254.169.254/1.0/meta-data/hostname/ | grep -q ec2.internal && echo "shutting down"
