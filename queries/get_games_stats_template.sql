SELECT g.GameID, stats.avg_stat
FROM Games g
JOIN (
    SELECT GameID AS gid, AVG({{STAT}}) AS avg_stat
    FROM PlayedIn
    GROUP BY GameID
) stats ON g.GameID = stats.gid
WHERE g.GameDate >= '{{START_DATE}}' AND g.GameDate <= '{{END_DATE}}';
