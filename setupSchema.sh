#!/bin/bash

source ~db2inst2/sqllib/db2profile

cp makeSchema.sql .tmp.sql
populate_players="dataFiles/populatePlayers.sql"
populate_teams="dataFiles/populateTeams.sql"
populate_hasplayers="dataFiles/populateHasPlayer.sql"
populate_users="dataFiles/populateUsers.sql"
cat $populate_players >> .tmp.sql
cat $populate_teams >> .tmp.sql
cat $populate_hasplayers >> .tmp.sql
cat $populate_users >> .tmp.sql

# connect to database
db2 connect to cs348

db2 -tf .tmp.sql 
