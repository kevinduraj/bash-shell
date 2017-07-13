#!/bin/bash
# start rsync in the background and have the script 
# loop until 8 am before it kills the process
#---------------------------------------------------------------#
rsync --bwlimit=1000 -var root@192.168.1.64:/home/mysql /home &
pid=$!

while /bin/true; do
  if [ $(date +%H) -ge 8 ]; then
    kill -TERM $pid
    exit 0
  else
    sleep 60
  fi
done
#---------------------------------------------------------------#
