SELECT GameID, avg FROM 
Games g JOIN (
    SELECT GameID as gid, AVG(TotalRebounds) as avg
    FROM PlayedIn
    GROUP BY GameID
) ON g.GameID = gid
WHERE g.GameDate >= '2024-11-01' AND g.GameDate <= '2024-11-05';