WITH TeamAverage AS (
SELECT AVG(FieldGoalAttempt) as avg
FROM Player p, HasPlayer hp, Teams t WHERE p.PlayerID = hp.PlayerID and t.TeamID = hp.TeamID and t.TeamName = 'Toronto Raptors'
)
SELECT *
FROM TeamAverage;
