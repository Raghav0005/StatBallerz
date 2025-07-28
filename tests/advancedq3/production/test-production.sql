SELECT PlayerID, PName
FROM ALL_PLAYER_INFO
WHERE AveragePoints >= (
    SELECT AveragePoints FROM ALL_PLAYER_INFO WHERE PName = 'Lebron James'
)
INTERSECT
SELECT PlayerID, PName
FROM ALL_PLAYER_INFO
WHERE TotalAssists >= (
    SELECT TotalAssists FROM ALL_PLAYER_INFO WHERE PName = 'Stephen Curry'
);
