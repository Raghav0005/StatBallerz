SELECT 
    g.GameID,
    g.GameDate,
    ht.TeamName as HOME_TEAM,
    at.TeamName as AWAY_TEAM
FROM Games g
JOIN Teams ht ON g.HomeTeamID = ht.TeamID
JOIN Teams at ON g.AwayTeamID = at.TeamID
WHERE g.GameID IN ({{GAME_IDS}});