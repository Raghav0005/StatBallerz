SELECT p.PName, p.Rebounds
FROM Player p, HasPlayer hp, Teams t
WHERE p.PlayerID = hp.PlayerID and hp.teamID = t.teamID and t.TeamName = 'Toronto Raptors'
ORDER BY p.Rebounds DESC
LIMIT 5;
