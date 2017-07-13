#!/bin/bash
#-----------------------------------------------------------------------------#
#                             Repair Tables
#-----------------------------------------------------------------------------#
repair_tables()
{
  USERNAME="root"
  PASSWORD="xapian64"
  DATABASE=$1

  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo "$(date +"%Y-%m-%d %H:%M") REPAIR and OPTIMIZE TABLE "$DATABASE"."$E

      SQL="
           DELETE FROM $DATABASE.$E WHERE period = '2009-01-01';
           LOCK TABLES $DATABASE.$E WRITE;
           REPAIR TABLE $DATABASE.$E;
           OPTIMIZE TABLE $DATABASE.$E;
           UNLOCK TABLES; "

      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo $RES
      sleep 3;

  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#

#mydb="wbs engine1 engine3 engine5 engine7"
mydb="engine72"

for db in $mydb
do  
    echo "Database: is [$db]"
    repair_tables $db
done

#-----------------------------------------------------------------------------#
