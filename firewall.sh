#!/bin/bash

iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 3306 -j ACCEPT # home 
iptables -A INPUT -p tcp -s 69.13.39.0/24 --dport 3306 -j ACCEPT  # dallas
iptables -A INPUT -p tcp --dport 3306 -j DROP
#iptables -A INPUT -p tcp -s 166.154.133.0/24 --dport 3306 -j ACCEPT # work
#iptables -A INPUT -p tcp -s 127.0.0.1 --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP
