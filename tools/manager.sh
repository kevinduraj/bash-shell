#!/bin/bash                                                                                                                                                                                                                            
#---------------------------------------------------------------------#
action='start'
IP="192.168.0.5 192.168.0.14 192.168.0.15"
#---------------------------------------------------------------------#

for node in $IP
do 
  ssh root@$node rm -fR /var/lib/cassandra/data/cloud4/link5-6352c141584e11e69ee22d2bcaae7eb2/ 
done

#---------------------------------------------------------------------#
cassandra() {

  for node in $IP
  do 
    echo $node
    ssh $node service dse $action
    ssh $node service datastax-agent $action 
    ssh $node service opscenterd $action
    #ssh $node rm -fR /cassandra/*
  done

}
#---------------------------------------------------------------------#
