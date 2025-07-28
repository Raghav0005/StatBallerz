SELECT PlayerID, PName
FROM ALL_PLAYER_INFO
WHERE AveragePoints >= (
    SELECT AveragePoints FROM ALL_PLAYER_INFO WHERE PName = 'Lebron James'
)
INTERSECT
SELECT PlayerID, PName
FROM ALL_PLAYER_INFO
WHERE AverageFieldGoalAttempts >= (
    SELECT AverageFieldGoalAttempts FROM ALL_PLAYER_INFO WHERE PName = 'Victor Wembanyama'
);
