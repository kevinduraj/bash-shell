#!/bin/bash
#-------------------------------------------------#
source ~/.bashrc
cd /home/spider/1;

#sleep $(( $$ % 15 ))
#perl mapper.pl -task=g$1 >> /dev/null 2>&1 &

sleep $(( $$ % 45 ))
perl mapper.pl -task=g$1 >> /dev/null 2>&1 &

#sleep $(( $$ % 15 ))
#perl mapper.pl -task=g$1 >> /dev/null 2>&1 &

#-------------------------------------------------#
exit 0

