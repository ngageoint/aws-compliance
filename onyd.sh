#!/bin/sh
# This script enforces orginizational AWS instance standards enabling ease of VPC security accreditation.
# To implement, create a root users cron referencing this script in your Org's Linux AMI like below.
# root cront content: @reboot /var/lib/cloud/scripts/per-boot/onyd.sh
#
# 6/19/16: KF tested with RHEL-7.2_HVM_GA-20151112-x86_64-1-Hourly2-GP2 (ami-2051294a) and 
#                         amzn-ami-hvm-2016.03.2.x86_64-gp2 (ami-a4827dc9)
#
url="http://169.254.169.254/1.0/meta-data"
message="Oh No You Di'int! :) Shutting off so you can terminate me (and my volumes) and redeploy with corrected values using procedures found here: <wiki link here>"
email="admin-distro@your.org" #update this to your email address
arg="$1"
declare -A CHECK
#build key/value pairs where key is meta-data url endpoint to check if it returns a good value
#                   desired domain                desired key                  comma seperated list of sg's
CHECK=( [hostname]=".ec2.internal" [public-keys]="Org-Admins" [security-groups]="ssh-from-home","sg with whitespace" )

function notify {
   logger "      Error: $I of value \"$J\" not found on this instance. $message"
   metadata=$(curl -s http://169.254.169.254/2014-11-05/dynamic/instance-identity/document/)
   echo "      Error: onyd.sh mailer - $I of value \"$J\" not found on this instance. $message $metadata" | mail -s "Powering off your instance: $(hostname)" $email
}

function shutheroff () {
   notify
   [[ $arg != "noop" ]] && poweroff
}
function main () {
   IFS=","
   for I in "${!CHECK[@]}"
   do
    for J in ${CHECK[$I]}
    do
      curl -s $url/$I/ | grep -q $J || shutheroff $arg
    done
    #curl -s http://169.254.169.254/1.0/meta-data/hostname/ | grep -q ec2.internal || sudo poweroff"
   done
   unset IFS
}

main

#incorp this to add instance id and other details for compliance
#curl -s http://169.254.169.254/2016-04-19/dynamic/instance-identity/document/
