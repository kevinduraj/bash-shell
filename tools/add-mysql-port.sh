#!/bin/bash

iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

