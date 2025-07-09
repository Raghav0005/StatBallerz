#!/bin/bash

source ~db2inst2/sqllib/db2profile

cp makeSchema.sql .tmp.sql
populate_players="dataFiles/populatePlayers.sql"
populate_teams="dataFiles/populateTeams.sql"
populate_hasplayers="dataFiles/populateHasPlayer.sql"
populate_games="dataFiles/populateGames.sql"
populate_playedIn="dataFiles/populatePlayedIn.sql"
populate_users="dataFiles/populateUsers.sql"
echo "please wait while we populate the database..."
cat $populate_players >> .tmp.sql
echo "populated players"
cat $populate_teams >> .tmp.sql
echo "populated teams"
cat $populate_hasplayers >> .tmp.sql
echo "populated hasPlayers"
cat $populate_users >> .tmp.sql
echo "populated users"
cat $populate_games >> .tmp.sql
echo "populated games"
cat $populate_playedIn >> .tmp.sql
echo "populated playedIn"
cat insert_users.sql >> .tmp.sql

# connect to database
db2 connect to cs348

db2 -tf .tmp.sql > output.txt
