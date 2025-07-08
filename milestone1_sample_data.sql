INSERT INTO Users (Username, PW) Values
('admin', 'admin'),
('user1', 'password1'),
('user2', 'password2'),
('user3', 'password3'),
('user4', 'password4'),
('user5', 'password5'),
('user6', 'password6'),
('user7', 'password7'),
('user8', 'password8'),
('user9', 'password9'),
('user10', 'password10');

 -- =======================
-- Insert Sample Data
-- =======================

-- Insert into Teams
INSERT INTO Teams (TeamID, TeamName) VALUES
(1, 'Los Angeles Lakers'),
(2, 'Golden State Warriors'),
(3, 'Milwaukee Bucks'),
(4, 'Denver Nuggets'),
(5, 'San Antonio Spurs');

-- Insert into Player
INSERT INTO Player (PlayerID, PName, BirthDate, Height, BodyWeight, DraftYear, DraftRound, DraftPick, Country, School) VALUES
(1, 'LeBron James', '1984-12-30', 206, 113, 2003, 1, 1, 'USA', 'St. Vincent-St. Mary HS'),
(2, 'Stephen Curry', '1988-03-14', 188, 84, 2009, 1, 7, 'USA', 'Davidson'),
(3, 'Giannis Antetokounmpo', '1994-12-06', 211, 110, 2013, 1, 15, 'Greece', NULL),
(4, 'Nikola Jokic', '1995-02-19', 211, 129, 2014, 2, 41, 'Serbia', NULL),
(5, 'Victor Wembanyama', '2004-01-04', 224, 95, 2023, 1, 1, 'France', NULL);

-- Insert into Games (assuming Teams with IDs 1–5 already exist)
INSERT INTO Games (GameID, GameDate, GameType, Attendance, HomeTeamID, AwayTeamID, HomeTeamScore, AwayTeamScore, Winner) VALUES
(1001, '2024-10-25', 'Regular Season', 19000, 1, 2, 115, 110, 1),
(1002, '2024-10-26', 'Regular Season', 18000, 3, 4, 98, 105, 4),
(1003, '2024-10-27', 'Regular Season', 17000, 5, 1, 102, 120, 1),
(1004, '2025-05-01', 'Playoffs', 20000, 2, 4, 112, 117, 4);

-- Insert into PlayedIn
INSERT INTO PlayedIn (GameID, PlayerID, NumSeconds, Points, Assists, Blocks, Steals, TotalRebounds, FieldGoalAttempt, FieldGoalMade, ThreePointAttempt, ThreePointMade, FreeThrowAttempt, FreeThrowMade, PersonalFouls, Turnovers) VALUES
-- Game 1001: Lakers vs Warriors
(1001, 1, 2400, 30, 8, 1, 2, 10, 22, 12, 6, 2, 8, 6, 2, 3),
(1001, 2, 2300, 28, 6, 0, 1, 4, 18, 10, 10, 5, 4, 3, 1, 2),

-- Game 1002: Bucks vs Nuggets
(1002, 3, 2400, 25, 5, 2, 2, 12, 20, 11, 4, 1, 6, 3, 3, 4),
(1002, 4, 2450, 32, 9, 1, 1, 14, 24, 14, 2, 1, 7, 4, 2, 3),

-- Game 1003: Spurs vs Lakers
(1003, 5, 2100, 18, 2, 3, 1, 8, 16, 7, 3, 1, 5, 4, 2, 2),
(1003, 1, 2400, 35, 10, 1, 2, 11, 25, 14, 5, 2, 6, 5, 1, 2),

-- Game 1004: Warriors vs Nuggets
(1004, 2, 2400, 31, 7, 0, 2, 5, 21, 12, 12, 6, 5, 3, 2, 3),
(1004, 4, 2450, 27, 11, 1, 1, 13, 19, 10, 3, 2, 6, 5, 3, 2);