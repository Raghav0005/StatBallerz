DROP TABLE IF EXISTS QuizAttemptItems;
DROP TABLE IF EXISTS QuizAttempts;
DROP TABLE IF EXISTS Questions;
DROP TABLE IF EXISTS Answers;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS HasPlayer;

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
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber) ON DELETE CASCADE,
    FOREIGN KEY (AttemptID) REFERENCES QuizAttempts(AttemptID) ON DELETE CASCADE
);

CREATE TABLE Teams (
    TeamID   INTEGER NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    PRIMARY KEY (TeamID)
);

CREATE TABLE Player (
    PlayerID        INTEGER NOT NULL,
    PName           VARCHAR(100) NOT NULL,
    PlayerAge       INTEGER     NOT NULL,
    GamesPlayed     INTEGER     DEFAULT 0,
    FieldGoalAttempt INTEGER    DEFAULT 0,
    FieldGoalMade   INTEGER     DEFAULT 0,
    ThreePointMade  INTEGER     DEFAULT 0,
    ThreePointAttempt INTEGER   DEFAULT 0,
    FreeThrowMade   INTEGER     DEFAULT 0,
    FreeThrowAttempt INTEGER    DEFAULT 0,
    Rebounds        INTEGER     DEFAULT 0,
    Assists         INTEGER     DEFAULT 0,
    Steals          INTEGER     DEFAULT 0,
    Blocks          INTEGER     DEFAULT 0,
    Turnovers       INTEGER     DEFAULT 0,
    Points          INTEGER     DEFAULT 0,
    PRIMARY KEY (PlayerID)
);

-- Create a junction table to associate players with teams
CREATE TABLE HasPlayer (
    PlayerID INTEGER NOT NULL,
    TeamID INTEGER NOT NULL,
    PRIMARY KEY (PlayerID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE CASCADE
);

CREATE VIEW LEADERBOARD AS
SELECT Users.Username, MAX(AttemptScore) AS MaxScore
FROM
    Users
JOIN
    QuizAttempts ON Users.UserID = QuizAttempts.UserID
GROUP BY Username;
-- ORDER BY DURING THE SELECT QUERY - CANNOT INCLUDE ORDER BY IN VIEW DEFINITION
