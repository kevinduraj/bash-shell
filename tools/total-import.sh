#!/bin/bash
#------------------------------------------------------------------------------------------# 
nicenumber()
{
  integer=$(echo $1 | cut -d. -f1)      # left of the decimal
  decimal=$(echo $1 | cut -d. -f2)      # right of the decimal

  if [ $decimal != $1 ]; then
    result="${DD:="."}$decimal"
  fi  

  thousands=$integer
  result=''

  while [ $thousands -gt 999 ]; do
    remainder=$(($thousands % 1000))    # three least significant digits

    while [ ${#remainder} -lt 3 ] ; do  # force leading zeros as needed
      remainder="0$remainder"
    done

    thousands=$(($thousands / 1000))    # to left of remainder, if any
    result="${TD:=","}${remainder}${result}"    # builds right to left
  done

  nicenum="${thousands}${result}"
  printf "  %-15s %15s\n" $2 "$nicenum"
}
#------------------------------------------------------------------------------------------# 
tables() {
  mydb="interview.flights interview.flight_number interview.flight_airport  interview.flight_arrival"
  for db in $mydb 
  do  
    #number=$(nodetool cfstats $db | grep "Number of keys" | awk '{print $5}' )
    number=$(nodetool cfstats $db | grep "Number of keys" | awk '{print $5}' )
    nicenumber $number $db;
  done
}
#------------------------------------------------------------------------------------------# 
tables
