#!/bin/sh
# This script enforces orginizational AWS instance standards enabling ease of VPC security accreditation.
# To implement, create a root users cron referencing this script in your Org's Linux AMI like below.
# root cront content: @reboot /var/lib/cloud/scripts/per-boot/onyd.sh
#
# 6/19/16: KF
url="http://169.254.169.254/1.0/meta-data"
message="Oh No You Di'int. Shutting off so you can redeploy with corrected value using procedures found here: <wiki link here>"
declare -A CHECK
#build key/value pairs where key is meta-data url endpoint to check if it returns a good value
#                   desired domain                desired key
CHECK=( [hostname]=".ec2.internal" [public-keys]="fitz-pass" [security-groups]="ssh-from-home","test-sg" )

function shutheroff {
   logger "      Error: $I of value \"$J\" not found on this instance. $message"
   sudo poweroff
}
function main {
for I in "${!CHECK[@]}"
do
    for J in $(echo "${CHECK[$I]}" | sed "s/,/ /g")
    do
        curl -s $url/$I/ | grep -q $J || shutheroff
    done
    #curl -s http://169.254.169.254/1.0/meta-data/hostname/ | grep -q ec2.internal || sudo poweroff"
done
}

main
