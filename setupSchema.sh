#!/bin/bash

source ~db2inst2/sqllib/db2profile

cp makeSchema.sql .tmp.sql
milestone1_sample_data="milestone1_sample_data.sql"
cat $milestone1_sample_data >> .tmp.sql

# connect to database
db2 connect to cs348

db2 -tf .tmp.sql 
