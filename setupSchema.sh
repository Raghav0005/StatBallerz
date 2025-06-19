#!/bin/bash

source ~db2inst2/sqllib/db2profile

cp makeSchema.sql .tmp.sql

# connect to database
db2 connect to cs348

db2 -tf .tmp.sql 
