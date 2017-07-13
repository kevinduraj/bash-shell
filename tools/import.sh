#!/bin/bash

dse sqoop import-all-tables -m 1 --connect jdbc:mysql://108.210.29.50:3306/engine37 --username root --password xapian64 --cassandra-thrift-host 108.210.29.50 
--cassandra-create-schema --direct

