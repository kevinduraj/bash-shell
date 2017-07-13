#!/bin/bash
#-----------------------------------------------------------------------------#
repair_tables()
{
  USERNAME='root'
  PASSWORD='xapian64'
  DATABASE=$1

  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo "$(date +"%Y-%m-%d %H:%M") TABLE = "$DATABASE"."$E
      SQL="REPAIR TABLE $DATABASE.$E;"; echo $SQL
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; echo $RES
      
      SQL="OPTIMIZE TABLE $DATABASE.$E;"; echo $SQL
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; echo $RES

  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#
mydb="engine35 engine75"
for db in $mydb
do  
    echo "Database: is [$db]"
    repair_tables $db
done
#-----------------------------------------------------------------------------#
