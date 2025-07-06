#!/bin/bash

# $1 is file that you want to run
# For example to run 1.sql execute: ./runSqlFile.sh 1.sql

source ~db2inst2/sqllib/db2profile

# connect to database
db2 connect to cs348

db2 -tf $1
