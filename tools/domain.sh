#!/bin/bash

# awk -F'.' '{gsub("http://|/.*","")} NF>2{$1="";$0=substr($0, 2)}1' OFS='.' $1
# awk '{gsub("http://|/.*","")}1' $1 | sed 's/www.//' 

for i in $(awk '{gsub("http://|/.*","")}1' $1 ); do dig soa $i | grep -v ^\; | grep SOA | awk '{print $1}'; done

