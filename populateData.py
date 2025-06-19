import csv
import sqlite3

file_path_in = "data.csv"
playerFile = "dataFiles/populatePlayers.sql"
teamPath = "dataFiles/populateTeams.sql"
statsPath = "dataFiles/populatePlayers.sql"
hasPlayerPath = "dataFiles/populateHasPlayer.sql"
seenTeams = set()
seenPlayers = set()

playerID = 0

team_abbreviations = {
    'ATL': 'Atlanta Hawks',
    'BOS': 'Boston Celtics',
    'BKN': 'Brooklyn Nets',
    'CHA': 'Charlotte Hornets',
    'CHI': 'Chicago Bulls',
    'CLE': 'Cleveland Cavaliers',
    'DAL': 'Dallas Mavericks',
    'DEN': 'Denver Nuggets',
    'DET': 'Detroit Pistons',
    'GSW': 'Golden State Warriors',
    'HOU': 'Houston Rockets',
    'IND': 'Indiana Pacers',
    'LAC': 'Los Angeles Clippers',
    'LAL': 'Los Angeles Lakers',
    'MEM': 'Memphis Grizzlies',
    'MIA': 'Miami Heat',
    'MIL': 'Milwaukee Bucks',
    'MIN': 'Minnesota Timberwolves',
    'NOP': 'New Orleans Pelicans',
    'NYK': 'New York Knicks',
    'OKC': 'Oklahoma City Thunder',
    'ORL': 'Orlando Magic',
    'PHI': 'Philadelphia 76ers',
    'PHX': 'Phoenix Suns',
    'POR': 'Portland Trail Blazers',
    'SAC': 'Sacramento Kings',
    'SAS': 'San Antonio Spurs',
    'TOR': 'Toronto Raptors',
    'UTA': 'Utah Jazz',
    'WAS': 'Washington Wizards'
}

playerToID = {}
teamToID = {}
playerToTeam = {}

with open(file_path_in, 'r', encoding='utf-8') as csvfile, open(statsPath, 'w', encoding='utf-8') as statsFile, open(teamPath, 'w', encoding='utf-8') as teamFile, open(hasPlayerPath, 'w', encoding='utf-8') as hasPlayerFile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        PLAYER_NAME = row['full_name']
        PLAYER_NAMED = PLAYER_NAME.replace("'", "''")
        PLAYER_AGE = row['PLAYER_AGE']
        GP = row['GP']
        GS = row['GS']
        MINUTES = row['MIN']
        FGM = row['FGM']
        FGA = row['FGA']
        FG3M = row['FG3M']
        FG3A = row['FG3A']
        FTM = row['FTM']
        FTA = row['FTA']
        OREB = row['OREB']
        DREB = row['DREB']
        REB = row['REB']
        AST = row['AST']
        STL = row['STL']
        BLK = row['BLK']
        TOV = row['TOV']
        PF = row['PF']
        PTS = row['PTS']
        TEAM_ABBR = row['TEAM_ABBREVIATION']
        SEASON_ID = row['SEASON_ID']
        TEAM = team_abbreviations.get(TEAM_ABBR, TEAM_ABBR)

        if SEASON_ID == '2024-25' and (TEAM == "Toronto Raptors" or int(GP) > 75 and TEAM != "TOT") and PLAYER_NAME not in playerToID:
            playerToTeam[PLAYER_NAME] = TEAM
            playerToID[PLAYER_NAME] = playerID
            statsFile.write(
                    f"INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) "
                    f"VALUES ('{playerID}', '{PLAYER_NAMED}', '{PLAYER_AGE}', '{GP}', '{FGA}', '{FGM}', '{FG3M}', '{FG3A}', "
                    f"'{FTM}', '{FTA}', '{REB}', '{AST}', '{STL}', '{BLK}', '{TOV}', '{PTS}');\n"
            )
            playerID += 1
    
    teams = 0
    for k,v in team_abbreviations.items():
        teamToID[v] = teams
        teamFile.write(f"INSERT INTO Teams (TeamID, TeamName) VALUES ('{teams}' ,'{v}');\n")
        teams += 1
    
    for k,v in playerToID.items():
        pTeamID = teamToID[playerToTeam[k]]
        hasPlayerFile.write(f"INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('{v}', '{pTeamID}');\n")