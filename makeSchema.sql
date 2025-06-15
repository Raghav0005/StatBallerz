drop table if exists Users;
drop table if exists Questions;
drop table if exists Answers;
drop table if exists Teams;
drop table if exists Players;

CREATE TABLE Users (
    UserID    INTEGER NOT NULL
                GENERATED ALWAYS AS IDENTITY 
                  (START WITH 1, INCREMENT BY 1),
    Username  VARCHAR(100)  NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserID)
);

CREATE TABLE Questions (
    QuestionID   INTEGER NOT NULL
                    GENERATED ALWAYS AS IDENTITY 
                      (START WITH 1, INCREMENT BY 1),
    AuthorID     INTEGER NOT NULL,
    QuestionText VARCHAR(200) NOT NULL,
    PRIMARY KEY (QuestionID),
    FOREIGN KEY (AuthorID) REFERENCES Users(UserID)
);

CREATE TABLE Answers (
    QuestionID   INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL,
    ResponseText VARCHAR(200) NOT NULL,
    IsCorrect      BOOLEAN NOT NULL,
    PRIMARY KEY (QuestionID, AnswerNumber),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);

CREATE TABLE Quizzes (
    QuizID  INTEGER NOT NULL
                    GENERATED ALWAYS AS IDENTITY 
                      (START WITH 1, INCREMENT BY 1),
    Title VARCHAR(100) NOT NULL,
    AuthorID     INTEGER NOT NULL,
    PRIMARY KEY (QuizID),
    FOREIGN KEY (AuthorID) REFERENCES Users(UserID)
);

CREATE TABLE QuizQuestions (
    QuizID INTEGER NOT NULL,
    QuestionID INTEGER NOT NULL,
    PRIMARY KEY (QuizID, QuestionID),
    FOREIGN KEY QuizID REFERENCES Quizzes(QuizID),
    FOREIGN KEY QuestionID REFERENCES Questions(QuestionID)
);

CREATE TABLE QuizAttempts (
    QuizID INTEGER NOT NULL,
    QuizTaker INTEGER NOT NULL,
    AttemptNumber INTEGER NOT NULL,
    Score INTEGER NOT NULL,
    PRIMARY KEY (QuizID, QuizTaker, AttemptNumber),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID),
    FOREIGN KEY (QuizTaker) REFERENCES Users(UserID)
);

CREATE TABLE QuizAttemptAnswers (
    QuizID INTEGER NOT NULL,
    QuizTaker INTEGER NOT NULL,
    AttemptNumber INTEGER NOT NULL,
    QuestionID INTEGER NOT NULL,
    AnswerNumber INTEGER NOT NULL,
    PRIMARY KEY (QuizID, QuizTaker, AttemptNumber, QuestionID, AnswerNumber),
    FOREIGN KEY (QuizID, QuizTaker, AttemptNumber) REFERENCES QuizAttempts (QuizID, QuizTaker, AttemptNumber),
    FOREIGN KEY (QuestionID, AnswerNumber) REFERENCES Answers(QuestionID, AnswerNumber)
);

CREATE TABLE Teams (
    TeamID   INTEGER NOT NULL
                GENERATED ALWAYS AS IDENTITY 
                  (START WITH 1, INCREMENT BY 1),
    TeamName VARCHAR(100) NOT NULL,
    PRIMARY KEY (TeamID)
);

CREATE TABLE TeamSeasons (
    TeamID INTEGER NOT NULL,
    SeasonStartYear INTEGER NOT NULL,
    SeasonEndYear INTEGER NOT NULL,
    SeasonRanking INTEGER,
    PRIMARY KEY (TeamID, SeasonStartYear),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Players (
    PlayerID        INTEGER NOT NULL
                       GENERATED ALWAYS AS IDENTITY 
                         (START WITH 1, INCREMENT BY 1),
    PName           VARCHAR(100) NOT NULL,
    PRIMARY KEY (PlayerID)
);

CREATE TABLE PlayerStats (
    PlayerID INTEGER NOT NULL,
    TeamID INTEGER NOT NULL,
    SeasonStartYear INTEGER NOT NULL,
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
    PRIMARY KEY (PlayerID, TeamID, SeasonStartYear),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (TeamID, SeasonStartYear) REFERENCES TeamSeasons(TeamID, SeasonStartYear)
);
