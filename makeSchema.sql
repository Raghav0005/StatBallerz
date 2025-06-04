drop table if exists Users;
drop table if exists Questions;
drop table if exists Answers;
drop table if exists Teams;
drop table if exists Players;

CREATE TABLE Users (
    userID    INTEGER NOT NULL
                GENERATED ALWAYS AS IDENTITY 
                  (START WITH 1, INCREMENT BY 1),
    Username  VARCHAR(100)  NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    HighestQuizSzt INTEGER      DEFAULT 0,
    PRIMARY KEY (userID)
);

CREATE TABLE Questions (
    QuestionID   INTEGER NOT NULL
                    GENERATED ALWAYS AS IDENTITY 
                      (START WITH 1, INCREMENT BY 1),
    AuthorID     INTEGER NOT NULL,
    QuestionText VARCHAR(200) NOT NULL,
    PRIMARY KEY (QuestionID),
    FOREIGN KEY (AuthorID) REFERENCES Users(userID)
);

CREATE TABLE Answers (
    QuestionID   INTEGER NOT NULL,
    ResponseText VARCHAR(200) NOT NULL,
    Correct      CHAR(1) NOT NULL CHECK (Correct IN ('T', 'F')),
    PRIMARY KEY (QuestionID, ResponseText),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);

CREATE TABLE Teams (
    TeamID   INTEGER NOT NULL
                GENERATED ALWAYS AS IDENTITY 
                  (START WITH 1, INCREMENT BY 1),
    TeamName VARCHAR(100) NOT NULL,
    Ranking  INTEGER,
    PRIMARY KEY (TeamID)
);

CREATE TABLE Players (
    PlayerID        INTEGER NOT NULL
                       GENERATED ALWAYS AS IDENTITY 
                         (START WITH 1, INCREMENT BY 1),
    Pname           VARCHAR(100) NOT NULL,
    TeamID          INTEGER     NOT NULL,
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
    PRIMARY KEY (PlayerID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
