#!/usr/bin/bash
#--------------------------------------------------------------------#

COHORT='cohort.all.tmp'
COHORT_UNIQUE='cohort.unique.tmp'

#--------------------------------------------------------------------#
#               Transform DateTime to Linux Date 
#--------------------------------------------------------------------#
transformation() {

  ./1-transform.pl
  
  echo "Users log sorting, Please wait ..."
  sort -S 4G --parallel=4 users.transformed.tmp | tee users.sorted.tmp &> /dev/null

  echo "Events log sorting, Please wait ..."
  sort -S 4G --parallel=4 events.transformed.tmp | tee events.sorted.tmp &> /dev/null

}

#--------------------------------------------------------------------#
#                 Format Nice Number 
#--------------------------------------------------------------------#
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
  regex=`echo "$2" | sed -r 's/_/ /g'`

  if [ "$3" = "reverse" ]; then
    printf "  %-10s %20s\n"  "$nicenum" "$regex"
  else 
    printf "  %-40s %10s\n" "$regex" "$nicenum"
  fi
 
}

#--------------------------------------------------------------------#
#                  Analyze Top Level and Reply 
#--------------------------------------------------------------------#
analyze_toplevel() {

  toplevel=$(cat events.sorted.tmp | grep "top-level" | wc | awk '{print $1}')
  reply=$(cat events.sorted.tmp | grep "reply" | wc | awk '{print $1}')

  clear;
  echo "------------- Total Top-Level and Reply --------------"
  echo "Total Top-Level: " $toplevel
  echo "Total Reply    : " $reply
}
#--------------------------------------------------------------------#
#                     Analyze OS Total
#--------------------------------------------------------------------#
analyze_os_total() {
  
  echo "-------------- Top 25 Operating System By User  ----------------"
  cat users.sorted.tmp | awk '{ print $4}' | tee os.tmp &>/dev/null 
  sort -S 4G --parallel=4 -u os.tmp | tee os.unique.tmp &>/dev/null

  for single in `cat os.unique.tmp`
  do
    res1=`cat os.tmp | grep $single | wc | awk '{print $1}'`
    nicenumber "$res1" "$single" "reverse" | tee -a os.total.tmp &>/dev/null
  done

  sort -nr os.total.tmp | head -25 | tee os.25.tmp
  echo "------------ Top 25 Operating Systems ---------------"
  cat os.25.tmp

}

#--------------------------------------------------------------------#
#                     Analyze Cohort Total
#--------------------------------------------------------------------#
analyze_cohort_total() {
  
  echo "--------------- Analyze Cohort Total -----------------"
  cat events.sorted.tmp | awk '{ print $4}' | tee $COHORT &>/dev/null 
  sort -S 4G --parallel=4 -u $COHORT | tee $COHORT_UNIQUE &>/dev/null

  for single in `cat $COHORT_UNIQUE`
  do
    res1=`cat $COHORT | grep $single | wc | awk '{print $1}'`
    nicenumber $res1 "$single"
  done
}
#--------------------------------------------------------------------#
#                     Analyze Cohort Detail 
#--------------------------------------------------------------------#
analyze_cohort_detail() {
  
  echo "-------------- Analyze Cohort Detail -----------------"
  cat events.sorted.tmp | awk '{ print $4"_"$3}' | tee $COHORT &>/dev/null 
  sort -S 4G --parallel=4 -u $COHORT | tee $COHORT_UNIQUE &>/dev/null

  for single in `cat $COHORT_UNIQUE`
  do
    res1=`cat $COHORT | grep $single | wc | awk '{print $1}'`
    nicenumber $res1 "$single"
  done
}
#--------------------------------------------------------------------#
#                     Undefined Cohort Details
#--------------------------------------------------------------------#
analyze_cohort_undefined() {

  echo "------------- Analyze Cohort Undefined ---------------"
  cat events.sorted.tmp | awk '{ print $4"_"$3"_"$6"_"$7}' | tee $COHORT &>/dev/null 
  sort -S 4G --parallel=4 -u $COHORT | tee $COHORT_UNIQUE &>/dev/null

  for single in `cat $COHORT_UNIQUE`
  do
    res1=`cat $COHORT | grep $single | wc | awk '{print $1}'`
    #res2=`echo $single | perl -pe 's/_/ /g'`
    nicenumber $res1 "$single"
  done
}


#--------------------------------------------------------------------#

transformation
analyze_toplevel
analyze_os_total
analyze_cohort_total
analyze_cohort_detail
analyze_cohort_undefined

# cleanup temporary files
rm -f *.tmp
#--------------------------------------------------------------------#
