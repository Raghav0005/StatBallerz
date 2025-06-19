WITH TeamAverage AS (
SELECT AVG(FieldGoalAttempt)
FROM Player p, Teams t WHERE t.TeamName = 'Toronto Raptors'
)
SELECT *
FROM TeamAverage;
