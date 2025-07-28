DROP TABLE IF EXISTS QuizAttemptItems;
DROP TABLE IF EXISTS QuizAttempts;
DROP TABLE IF EXISTS PlayerAnswer;
DROP TABLE IF EXISTS TeamAnswer;
DROP TABLE IF EXISTS PlayedIn;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS HasPlayer;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Answers;
DROP TABLE IF EXISTS Questions;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    UserID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    Username VARCHAR(100) NOT NULL UNIQUE,
    PW VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserID)
);

CREATE TABLE Questions (
    QuestionID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    AuthorID INTEGER NOT NULL,
    QuestionText VARCHAR(200) NOT NULL,
    PRIMARY KEY (QuestionID),
    FOREIGN KEY (AuthorID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE Answers (
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL CHECK(AnswerNumber <= 4 and AnswerNumber >= 1),
    ResponseText VARCHAR(200) NOT NULL,
    IsCorrect      BOOLEAN NOT NULL,
    PRIMARY KEY (QuestionID, AnswerNumber),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);

CREATE TABLE QuizAttempts (
    AttemptID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    UserID INTEGER NOT NULL,
    AttemptScore INTEGER DEFAULT 0 CHECK (AttemptScore >= 0),
    PRIMARY KEY (AttemptID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE QuizAttemptItems (
    AttemptID INTEGER NOT NULL,
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL CHECK(AnswerNumber <= 4 and AnswerNumber >= 1),
    PRIMARY KEY (AttemptID, QuestionID),
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber) ON DELETE CASCADE,
    FOREIGN KEY (AttemptID) REFERENCES QuizAttempts(AttemptID) ON DELETE CASCADE
);

CREATE TABLE Teams (
    TeamID   INTEGER NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    PRIMARY KEY (TeamID)
);

CREATE TABLE Player (
    PlayerID INTEGER NOT NULL,
    PName VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    Height INTEGER,
    BodyWeight INTEGER,
    DraftYear INTEGER,
    DraftRound INTEGER,
    DraftPick INTEGER,
    Country VARCHAR(100) NOT NULL,
    School VARCHAR(100),
    PRIMARY KEY (PlayerID)
);

CREATE TABLE Games (
    GameID INTEGER NOT NULL,
    GameDate DATE NOT NULL,
    GameType VARCHAR(50) NOT NULL CHECK (GameType IN ('Regular Season', 'Playoffs')),
    Attendance INTEGER NOT NULL CHECK (Attendance >= 0),
    HomeTeamID INTEGER NOT NULL,
    AwayTeamID INTEGER NOT NULL,
    HomeTeamScore INTEGER DEFAULT 0 CHECK (HomeTeamScore >= 0),
    AwayTeamScore INTEGER DEFAULT 0 CHECK (AwayTeamScore >= 0),
    Winner INTEGER DEFAULT NULL,
    PRIMARY KEY (GameID),
    FOREIGN KEY (HomeTeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE
);

CREATE TABLE PlayedIn (
    GameID INTEGER NOT NULL,
    PlayerID INTEGER NOT NULL,
    NumSeconds INTEGER CHECK (NumSeconds >= 0),
    Points INTEGER DEFAULT 0 CHECK (Points >= 0),
    Assists INTEGER DEFAULT 0 CHECK (Assists >= 0),
    Blocks INTEGER DEFAULT 0 CHECK (Blocks >= 0),
    Steals INTEGER DEFAULT 0 CHECK (Steals >= 0),
    TotalRebounds INTEGER DEFAULT 0 CHECK (TotalRebounds >= 0),
    FieldGoalAttempt INTEGER DEFAULT 0 CHECK (FieldGoalAttempt >= 0),
    FieldGoalMade INTEGER DEFAULT 0 CHECK (FieldGoalMade >= 0),
    ThreePointAttempt INTEGER DEFAULT 0 CHECK (ThreePointAttempt >= 0),
    ThreePointMade INTEGER DEFAULT 0 CHECK (ThreePointMade >= 0),
    FreeThrowAttempt INTEGER DEFAULT 0 CHECK (FreeThrowAttempt >= 0),
    FreeThrowMade INTEGER DEFAULT 0 CHECK (FreeThrowMade >= 0),
    PersonalFouls INTEGER DEFAULT 0 CHECK (PersonalFouls >= 0),
    Turnovers INTEGER DEFAULT 0 CHECK (Turnovers >= 0),
    PRIMARY KEY (GameID, PlayerID),
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE,
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE
);

-- Create a junction table to associate players with teams
CREATE TABLE HasPlayer (
    PlayerID INTEGER NOT NULL,
    TeamID INTEGER NOT NULL,
    PRIMARY KEY (PlayerID, TeamID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE
);

CREATE TABLE PlayerAnswer (
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL CHECK(AnswerNumber <= 4 and AnswerNumber >= 1),
    PlayerID INTEGER NOT NULL,
    PRIMARY KEY (QuestionID, AnswerNumber),
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber) ON DELETE CASCADE,
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE
);

CREATE TABLE TeamAnswer (
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL CHECK(AnswerNumber <= 4 and AnswerNumber >= 1),
    TeamID INTEGER NOT NULL,
    PRIMARY KEY (QuestionID, AnswerNumber),
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE
);

-- Views
CREATE OR REPLACE VIEW LEADERBOARD AS
SELECT Users.Username, MAX(AttemptScore) AS MaxScore
FROM
    Users
JOIN
    QuizAttempts ON Users.UserID = QuizAttempts.UserID
GROUP BY Username;
-- ORDER BY DURING THE SELECT QUERY - CANNOT INCLUDE ORDER BY IN VIEW DEFINITION

CREATE OR REPLACE VIEW ALL_PLAYER_INFO AS
SELECT
    Player.PlayerID,
    Player.PName,
    Player.Height,
    Player.BodyWeight,
    Player.DraftYear,
    Player.DraftRound,
    Player.DraftPick,
    Player.Country,
    Player.School,
    COUNT(Player.PlayerID) AS GamesPlayed,
    SUM(PlayedIn.Points) AS TotalPoints,
    AVG(PlayedIn.Points) AS AveragePoints,
    SUM(PlayedIn.Assists) AS TotalAssists,
    AVG(PlayedIn.Assists) AS AverageAssists,
    SUM(PlayedIn.Blocks) AS TotalBlocks,
    AVG(PlayedIn.Blocks) AS AverageBlocks,
    SUM(PlayedIn.Steals) AS TotalSteals,
    AVG(PlayedIn.Steals) AS AverageSteals,
    SUM(PlayedIn.TotalRebounds) AS TotalRebounds,
    AVG(PlayedIn.TotalRebounds) AS AverageRebounds,
    SUM(PlayedIn.FieldGoalAttempt) AS TotalFieldGoalAttempts,
    AVG(PlayedIn.FieldGoalAttempt) AS AverageFieldGoalAttempts,
    SUM(PlayedIn.FieldGoalMade) AS TotalFieldGoalsMade,
    AVG(PlayedIn.FieldGoalMade) AS AverageFieldGoalsMade,
    SUM(PlayedIn.ThreePointAttempt) AS TotalThreePointAttempts,
    AVG(PlayedIn.ThreePointAttempt) AS AverageThreePointAttempts,
    SUM(PlayedIn.ThreePointMade) AS TotalThreePointersMade,
    AVG(PlayedIn.ThreePointMade) AS AverageThreePointersMade,
    SUM(PlayedIn.FreeThrowAttempt) AS TotalFreeThrowAttempts,
    AVG(PlayedIn.FreeThrowAttempt) AS AverageFreeThrowAttempts,
    SUM(PlayedIn.FreeThrowMade) AS TotalFreeThrowsMade,
    AVG(PlayedIn.FreeThrowMade) AS AverageFreeThrowsMade,
    SUM(PlayedIn.PersonalFouls) AS TotalPersonalFouls,
    AVG(PlayedIn.PersonalFouls) AS AveragePersonalFouls,
    SUM(PlayedIn.Turnovers) AS TotalTurnovers,
    AVG(PlayedIn.Turnovers) AS AverageTurnovers
FROM
    Player
LEFT JOIN
    PlayedIn ON Player.PlayerID = PlayedIn.PlayerID
GROUP BY
    Player.PlayerID,
    Player.PName,
    Player.Height,
    Player.BodyWeight,
    Player.DraftYear,
    Player.DraftRound,
    Player.DraftPick,
    Player.Country,
    Player.School;

CREATE OR REPLACE VIEW ALL_GAME_INFO AS
SELECT
    Games.GameID,
    Games.GameDate,
    Games.GameType,
    Games.Attendance,
    HomeTeam.TeamName AS HomeTeamName,
    AwayTeam.TeamName AS AwayTeamName,
    Games.HomeTeamScore,
    Games.AwayTeamScore,
    Winner.TeamName AS WinnerTeamName
FROM
    Games
JOIN
    Teams AS HomeTeam ON Games.HomeTeamID = HomeTeam.TeamID
JOIN
    Teams AS AwayTeam ON Games.AwayTeamID = AwayTeam.TeamID
LEFT JOIN
    Teams AS Winner ON Games.Winner = Winner.TeamID;

-- =======================
-- Insert Sample Data
-- =======================

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
('user10', 'password10'),
('Joe', 'Mama');

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


INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Which player scored the most points in Game 1001?'),
(1, 'Which team won Game 1003?'),
(1, 'Who had the most assists in Game 1004?'),
(1, 'Which player had the most rebounds in Game 1002?');

INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(1, 1, 'LeBron James', TRUE),
(1, 2, 'Stephen Curry', FALSE),
(1, 3, 'Giannis Antetokounmpo', FALSE),
(1, 4, 'Nikola Jokic', FALSE),
(2, 1, 'Los Angeles Lakers', TRUE),
(2, 2, 'San Antonio Spurs', FALSE),
(2, 3, 'Golden State Warriors', FALSE),
(2, 4, 'Milwaukee Bucks', FALSE),
(3, 1, 'Nikola Jokic', TRUE),
(3, 2, 'Stephen Curry', FALSE),
(3, 3, 'Victor Wembanyama', FALSE),
(3, 4, 'Giannis Antetokounmpo', FALSE),
(4, 1, 'Giannis Antetokounmpo', FALSE),
(4, 2, 'Nikola Jokic', TRUE),
(4, 3, 'LeBron James', FALSE),
(4, 4, 'Victor Wembanyama', FALSE);

INSERT INTO PlayerAnswer (QuestionID, AnswerNumber, PlayerID) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(3, 1, 4),
(3, 2, 2),
(3, 3, 5),
(3, 4, 3),
(4, 1, 3),
(4, 2, 4),
(4, 3, 1),
(4, 4, 5);

INSERT INTO TeamAnswer (QuestionID, AnswerNumber, TeamID) VALUES
(2, 1, 1),
(2, 2, 5),
(2, 3, 2),
(2, 4, 3);

INSERT INTO QuizAttempts (UserID, AttemptScore) VALUES
(2, 3),
(3, 3),
(4, 2),
(5, 1);

INSERT INTO QuizAttemptItems (AttemptID, QuestionID, AnswerNumber) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1, 4, 2),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(2, 4, 2),
(3, 1, 1),
(3, 2, 2),
(4, 2, 3);