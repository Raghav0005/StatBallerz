DROP TABLE IF EXISTS QuizAttemptItems;
DROP TABLE IF EXISTS QuizAttempts;
DROP TABLE IF EXISTS PlayerAnswer;
DROP TABLE IF EXISTS GameAnswer;
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
    FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (Winner) REFERENCES Teams(TeamID) ON DELETE SET NULL
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

CREATE TABLE GameAnswer (
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL CHECK(AnswerNumber <= 4 and AnswerNumber >= 1),
    GameID INTEGER NOT NULL,
    PRIMARY KEY (QuestionID, AnswerNumber),
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_games_date ON Games(GameDate);

CREATE INDEX idx_playedin_points ON PlayedIn(Points);
CREATE INDEX idx_playedin_assists ON PlayedIn(Assists);
CREATE INDEX idx_playedin_rebounds ON PlayedIn(TotalRebounds);

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