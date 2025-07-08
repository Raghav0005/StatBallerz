import csv
import sqlite3
import pandas as pd
from collections import defaultdict

player_stats = pd.read_csv("totalData/PlayerStatsCurSeason.csv", low_memory=False)
team_stats = pd.read_csv("totalData/TeamStatistics.csv")
game_stats = pd.read_csv("totalData/Games.csv", low_memory=False)
team_histories = pd.read_csv("totalData/TeamHistories.csv")
player_info = pd.read_csv("totalData/common_player_info.csv")
league_schedule = pd.read_csv("totalData/LeagueSchedule24_25.csv")

playersOut = "dataFiles/populatePlayers.sql"
teamsOut = "dataFiles/populateTeams.sql"
gamesOut = "dataFiles/populateGames.sql"
playedInOut = "dataFiles/populatePlayedIn.sql"
hasPlayerOut = "dataFiles/populateHasPlayer.sql"

# Creating the dataframe for current player data
uniqueCurPID = player_stats['personId'].unique()
filteredPlayerInfo = player_info[player_info['person_id'].isin(uniqueCurPID)]
filteredGameInfo = game_stats[game_stats['gameId'].isin(league_schedule['gameId'])]


teamNameToID = {}
teamIDs = set()
gameIDs = set()
players = set()
pIdToTeam = defaultdict(list)

# Populate the Player Info 
with open(playersOut, 'w', encoding='utf-8') as playersOutFile:
    for index,row in filteredPlayerInfo.iterrows():
        playerId = row['person_id']
        firstName = row['first_name']
        lastName = row['last_name']
        heightTot = row['height']
        weight = row['weight']
        draftYear = row['draft_year']
        draftRound = row['draft_round']
        draftPick = row['draft_number']
        country = row['country']
        unprocessedSchool = row['school']
        birthDate = row['birthdate']
        unProcessedName = row['display_first_last']
        fullName = unProcessedName.replace("'", "''")
        school = unprocessedSchool.replace("'", "''")
        
        if draftYear == 'Undrafted' or pd.isna(draftPick):
            draftYear = 'NULL'
            draftRound = 'NULL'
            draftPick = 'NULL'


        height = None
        players.add(playerId)
        if isinstance(heightTot, str):
            feet,inches = heightTot.split('-')
            height = (int(feet) * 12) + int(inches)
        else:
            height = 'NULL'
        
        if isinstance(weight, float):
            weight = 'NULL'

        sql = (
            f"INSERT INTO Player (PlayerID, PName, BirthDate, Height, BodyWeight, DraftYear, DraftRound, DraftPick, Country, School) VALUES " 
            f"({playerId}, '{fullName}', '{birthDate}', {height}, {weight}, {draftYear}, {draftRound}, {draftPick}, '{country}', '{school}');\n"
        )

        playersOutFile.write(sql)
        


with open(teamsOut, 'w', encoding='utf-8') as teamsOutFile:
    for index,row in team_histories.iterrows():
        if row['league'] == 'NBA' and row['seasonActiveTill'] == 2100:
            teamName = row['teamCity'] + " " + row['teamName']
            teamId = row['teamId']

            if 'All-Star' in teamName: continue
            if not teamId in teamIDs: teamIDs.add(teamId)
            sql = (
                f"INSERT INTO Teams (TeamID, TeamName) VALUES ({teamId}, '{teamName}');\n"
            )
            teamNameToID[row['teamName']] = teamId
            teamsOutFile.write(sql)

## Populate the Game Rows 
with open(gamesOut, 'w', encoding='utf-8') as gamesOutFile:
    for index,row in filteredGameInfo.iterrows():
        gameId = row['gameId']
        gameDate = row['gameDate']
        gameType = row['gameType']
        attendance = row['attendance']
        homeTeamID = row['hometeamId']
        awayTeamID = row['awayteamId']
        homeScore = row['homeScore']
        awayScore = row['awayScore']
        winner = row['winner']

        if homeTeamID in teamIDs and awayTeamID in teamIDs and gameType == 'Regular Season' or gameType == 'Playoffs':
            sql = (
                f"INSERT INTO Games (GameID, GameDate, GameType, Attendance, HomeTeamID, AwayTeamID, HomeTeamScore, AwayTeamScore, Winner) VALUES "
                f"({gameId}, '{gameDate}', '{gameType}', {attendance}, '{homeTeamID}', '{awayTeamID}', {homeScore}, {awayScore}, {winner});\n"
            )

            gameIDs.add(gameId)
            gamesOutFile.write(sql)

with open(playedInOut, 'w', encoding='utf-8') as playedInOutFile, open(hasPlayerOut, 'w', encoding='utf-8') as hasPlayerOutFile:
    for index,row in player_stats.iterrows():
        playerId = row['personId']
        gameId = row['gameId']
        numMinutes = row['numMinutes']
        mins,seconds = 0,0
        if isinstance(numMinutes, str): mins,seconds = numMinutes.split('.')
        numSeconds = int(mins) * 60 + int(seconds)
        points = row['points']
        assists = row['assists']
        rebounds = row['reboundsTotal']
        steals = row['steals']
        blocks = row['blocks']
        fieldGoalAttempted = row['fieldGoalsAttempted']
        fieldGoalMade = row['fieldGoalsMade']
        threePointAttempted = row['threePointersAttempted']
        threePointMade = row['threePointersMade']
        freeThrowAttempted = row['freeThrowsAttempted']
        freeThrowMade = row['freeThrowsMade']
        fouls = row['foulsPersonal']
        turnovers = row['turnovers']
        teamID = teamNameToID[row['playerteamName']]

        if (teamID not in pIdToTeam[playerId]) and (teamID in teamIDs) and (playerId in players):
            pIdToTeam[playerId].append(teamID)
            hasPlayerSql = f"INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ({playerId}, {teamID});\n"
            hasPlayerOutFile.write(hasPlayerSql)

        if gameId in gameIDs and playerId in players:
            playedInSql = (
                f"INSERT INTO PlayedIn (GameID, PlayerID, NumSeconds, Points, Assists, Blocks, Steals, TotalRebounds, "
                f"FieldGoalAttempt, FieldGoalMade, ThreePointAttempt, ThreePointMade, FreeThrowAttempt, FreeThrowMade, "
                f"PersonalFouls, Turnovers) VALUES "
                f"({gameId}, {playerId}, {numSeconds}, {points}, {assists}, {blocks}, {steals}, {rebounds}, {fieldGoalAttempted}, "
                f"{fieldGoalMade}, {threePointAttempted}, {threePointMade}, {freeThrowAttempted}, {freeThrowMade}, {fouls}, {turnovers});\n"
            )
            playedInOutFile.write(playedInSql)