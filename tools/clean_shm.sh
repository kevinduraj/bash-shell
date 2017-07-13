#!/bin/bash
#--- remove large files from shared memory


find /run/shm -type f -size +1000 -delete
find /run/shm -type f -mtime +1 -delete

#-----------------------------------------------#
# find . -type f -size +10000000 -delete
#-----------------------------------------------#
