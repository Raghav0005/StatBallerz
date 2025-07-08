SELECT g.GameID, stats.avg_points
FROM Games g
JOIN (
    SELECT GameID AS gid, AVG(Points) AS avg_points
    FROM PlayedIn
    GROUP BY GameID
) stats ON g.GameID = stats.gid
WHERE g.GameDate >= '2024-10-25' AND g.GameDate <= '2024-10-27';