DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS QAMap;
DROP TABLE IF EXISTS QuizAttemptItems;
DROP TABLE IF EXISTS QuizAttempts;
DROP TABLE IF EXISTS Questions;
DROP TABLE IF EXISTS Answers;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS HasPlayer;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Teams;

CREATE TABLE Users (
    UserID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    Username VARCHAR(100) NOT NULL UNIQUE,
    PW VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserID)
);

CREATE TABLE Questions (
    QuestionID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    QuestionText VARCHAR(200) NOT NULL,
    PRIMARY KEY (QuestionID)
);

CREATE TABLE Author (
    UserID INTEGER NOT NULL REFERENCES Users(UserID),
    QuestionID INTEGER NOT NULL REFERENCES Questions(QuestionID),
    PRIMARY KEY (UserID, QuestionID)
);

CREATE TABLE Answers (
    AnswerID   INTEGER NOT NULL,
    ResponseText VARCHAR(200) NOT NULL,
    IsCorrect      BOOLEAN NOT NULL,
    PRIMARY KEY (AnswerID)
);

CREATE TABLE QAMap (
    QuestionID   INTEGER NOT NULL,
    AnswerID   INTEGER NOT NULL,
    PRIMARY KEY (QuestionID, AnswerID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
    FOREIGN KEY (AnswerID) REFERENCES Answers(AnswerID)
);

-- CREATE TABLE hasAttempted (
--     AttemptID INTEGER NOT NULL,
--     UserID INTEGER NOT NULL,
--     PRIMARY KEY (AttemptID),
--     FOREIGN KEY (UserID) REFERENCES Users(UserID)
-- );

CREATE TABLE QuizAttempts (
    AttemptID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    UserID INTEGER NOT NULL,
    PRIMARY KEY (AttemptID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE QuizAttemptItems (
    AttemptID INTEGER NOT NULL,
    QuestionID INTEGER NOT NULL,
    AnswerID INTEGER NOT NULL,
    PRIMARY KEY (AttemptID, QuestionID),
    FOREIGN KEY (AttemptID) REFERENCES QuizAttempts(AttemptID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
    FOREIGN KEY (AnswerID) REFERENCES Answers(AnswerID)
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
    PRIMARY KEY (PlayerID, TeamID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('0', 'Bam Adebayo', '27', '78', '1113', '540', '79', '221', '251', '328', '749', '337', '98', '53', '161', '1410');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('1', 'Ochai Agbaji', '24', '64', '534', '266', '101', '253', '34', '48', '242', '98', '58', '30', '54', '667');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('2', 'Nickeil Alexander-Walker', '26', '82', '616', '270', '141', '370', '92', '118', '265', '223', '50', '34', '99', '773');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('3', 'Jarrett Allen', '27', '82', '640', '452', '0', '5', '199', '277', '798', '158', '77', '73', '97', '1103');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('4', 'Harrison Barnes', '32', '82', '683', '347', '156', '360', '161', '199', '310', '136', '39', '14', '50', '1011');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('5', 'Scottie Barnes', '23', '65', '1063', '474', '76', '280', '228', '302', '502', '378', '93', '63', '185', '1252');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('6', 'RJ Barrett', '24', '58', '982', '460', '107', '306', '196', '311', '366', '314', '46', '17', '165', '1223');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('7', 'Jamison Battle', '23', '59', '347', '149', '105', '259', '16', '18', '158', '53', '17', '10', '27', '419');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('8', 'Nicolas Batum', '36', '78', '238', '104', '88', '203', '17', '21', '218', '84', '52', '36', '34', '313');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('9', 'Malik Beasley', '28', '82', '1071', '461', '319', '766', '95', '140', '214', '139', '73', '5', '83', '1336');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('10', 'Anthony Black', '21', '78', '620', '262', '62', '195', '150', '197', '230', '240', '86', '48', '139', '736');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('11', 'Chris Boucher', '32', '50', '370', '182', '70', '193', '68', '87', '224', '33', '24', '25', '29', '502');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('12', 'Christian Braun', '24', '79', '821', '476', '89', '224', '177', '214', '410', '205', '85', '37', '81', '1218');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('13', 'Mikal Bridges', '28', '82', '1183', '592', '164', '463', '96', '118', '259', '306', '75', '43', '132', '1444');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('14', 'Bruce Brown', '28', '18', '131', '57', '11', '36', '26', '29', '68', '28', '17', '3', '19', '151');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('15', 'Matas Buzelis', '20', '80', '555', '252', '96', '266', '88', '108', '278', '79', '29', '75', '74', '688');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('16', 'Kentavious Caldwell-Pope', '32', '77', '544', '239', '113', '330', '82', '95', '169', '136', '99', '34', '62', '673');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('17', 'Toumani Camara', '24', '78', '716', '328', '135', '360', '91', '126', '450', '175', '116', '50', '109', '882');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('18', 'Bub Carrington', '19', '82', '748', '300', '138', '407', '69', '85', '341', '364', '54', '21', '141', '807');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('19', 'D.J. Carton', '24', '4', '7', '1', '0', '3', '1', '1', '4', '3', '2', '0', '4', '3');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('20', 'Stephon Castle', '20', '81', '988', '423', '95', '333', '249', '344', '297', '332', '74', '22', '177', '1190');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('21', 'Colin Castleton', '24', '11', '64', '32', '2', '8', '13', '18', '76', '18', '6', '8', '21', '79');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('22', 'Julian Champagnie', '23', '82', '665', '276', '178', '480', '85', '94', '318', '111', '61', '35', '74', '815');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('23', 'Ulrich Chomche', '19', '7', '5', '2', '0', '0', '1', '2', '8', '2', '0', '1', '2', '5');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('24', 'Dyson Daniels', '22', '76', '923', '455', '80', '235', '83', '140', '449', '333', '229', '55', '155', '1073');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('25', 'DeMar DeRozan', '35', '77', '1308', '624', '84', '256', '378', '441', '298', '342', '62', '32', '105', '1710');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('26', 'Gradey Dick', '21', '54', '647', '265', '114', '326', '133', '155', '193', '98', '48', '10', '83', '777');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('27', 'Spencer Dinwiddie', '32', '79', '682', '284', '109', '326', '195', '243', '209', '349', '70', '17', '102', '872');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('28', 'Jalen Duren', '21', '78', '546', '378', '0', '0', '162', '242', '807', '209', '54', '89', '136', '918');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('29', 'Anthony Edwards', '23', '79', '1612', '721', '320', '811', '415', '496', '450', '359', '91', '51', '249', '2177');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('30', 'Keon Ellis', '25', '80', '464', '227', '139', '321', '73', '86', '212', '120', '121', '63', '71', '666');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('31', 'Bruno Fernando', '26', '17', '49', '26', '0', '0', '6', '8', '51', '18', '4', '9', '14', '58');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('32', 'Shai Gilgeous-Alexander', '26', '76', '1656', '860', '163', '435', '601', '669', '379', '486', '131', '77', '183', '2484');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('33', 'Jalen Green', '23', '82', '1437', '608', '234', '661', '273', '336', '377', '282', '71', '27', '203', '1723');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('34', 'Tim Hardaway Jr.', '33', '77', '680', '276', '168', '457', '124', '145', '183', '123', '38', '7', '48', '844');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('35', 'James Harden', '35', '79', '1295', '531', '235', '668', '505', '578', '456', '687', '118', '55', '341', '1802');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('36', 'Josh Hart', '30', '77', '770', '404', '84', '252', '159', '205', '737', '453', '119', '27', '158', '1051');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('37', 'Tyler Herro', '25', '77', '1378', '651', '251', '670', '287', '327', '399', '424', '69', '17', '198', '1840');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('38', 'Buddy Hield', '32', '82', '786', '328', '203', '549', '53', '64', '264', '134', '69', '23', '91', '912');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('39', 'Ronald Holland II', '19', '81', '416', '197', '36', '151', '92', '122', '218', '82', '49', '17', '72', '522');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('40', 'Keldon Johnson', '25', '77', '770', '371', '87', '274', '150', '194', '371', '125', '49', '22', '77', '979');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('41', 'Keon Johnson', '23', '79', '779', '303', '126', '401', '107', '139', '297', '175', '82', '30', '116', '839');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('42', 'Tyus Jones', '28', '81', '683', '306', '166', '401', '51', '57', '196', '429', '69', '8', '91', '829');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('43', 'Derrick Jones Jr.', '28', '77', '589', '310', '78', '219', '83', '118', '263', '60', '79', '33', '66', '781');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('44', 'Dalton Knecht', '24', '78', '557', '257', '128', '340', '64', '84', '216', '66', '24', '8', '37', '706');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('45', 'A.J. Lawson', '24', '26', '190', '80', '33', '101', '43', '63', '86', '31', '13', '6', '15', '236');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('46', 'Kevon Looney', '29', '76', '278', '143', '2', '5', '56', '99', '462', '118', '46', '37', '39', '344');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('47', 'Brook Lopez', '37', '80', '774', '394', '139', '373', '114', '138', '401', '143', '50', '148', '84', '1041');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('48', 'T.J. McConnell', '33', '79', '624', '324', '15', '49', '57', '77', '193', '351', '83', '21', '109', '720');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('49', 'Jaden McDaniels', '24', '82', '834', '398', '100', '303', '104', '128', '470', '163', '110', '74', '95', '1000');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('50', 'Davion Mitchell', '26', '44', '244', '106', '42', '117', '25', '37', '85', '203', '31', '8', '78', '279');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('51', 'Jonathan Mogbo', '23', '63', '356', '156', '17', '70', '60', '82', '311', '146', '55', '34', '70', '389');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('52', 'Keegan Murray', '24', '76', '820', '364', '154', '449', '60', '72', '507', '109', '61', '69', '60', '942');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('53', 'Kelly Olynyk', '34', '24', '118', '59', '19', '43', '34', '43', '89', '56', '16', '8', '35', '171');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('54', 'Chris Paul', '39', '82', '583', '249', '140', '371', '85', '92', '296', '605', '103', '22', '129', '723');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('55', 'Julian Phillips', '21', '79', '287', '128', '50', '153', '60', '76', '169', '39', '38', '20', '27', '366');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('56', 'Scotty Pippen Jr.', '24', '79', '594', '285', '87', '219', '122', '171', '259', '347', '103', '30', '138', '779');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('57', 'Jakob Poeltl', '29', '57', '579', '363', '1', '3', '97', '144', '547', '158', '66', '71', '111', '824');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('58', 'Michael Porter Jr.', '26', '77', '1048', '528', '193', '489', '149', '194', '540', '165', '50', '38', '104', '1398');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('59', 'Taurean Prince', '31', '80', '514', '235', '147', '335', '39', '48', '287', '155', '76', '15', '82', '656');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('60', 'Payton Pritchard', '27', '80', '866', '409', '255', '626', '71', '84', '307', '279', '70', '14', '83', '1144');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('61', 'Immanuel Quickley', '25', '33', '438', '184', '85', '225', '111', '128', '117', '191', '23', '4', '58', '564');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('62', 'Naz Reid', '25', '80', '923', '426', '175', '462', '111', '143', '480', '181', '58', '72', '108', '1138');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('63', 'Jared Rhoden', '25', '10', '79', '40', '12', '37', '22', '25', '38', '14', '9', '2', '8', '114');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('64', 'Orlando Robinson', '24', '35', '244', '109', '16', '47', '50', '63', '206', '68', '14', '15', '45', '284');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('65', 'Alperen Sengun', '22', '76', '1143', '567', '21', '90', '296', '428', '786', '372', '84', '61', '194', '1451');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('66', 'Jamal Shead', '22', '75', '504', '204', '72', '223', '53', '69', '115', '316', '58', '10', '117', '533');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('67', 'Pascal Siakam', '31', '78', '1182', '613', '126', '324', '226', '308', '540', '263', '70', '42', '109', '1578');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('68', 'Cole Swider', '25', '8', '58', '22', '15', '42', '0', '1', '25', '2', '4', '2', '4', '59');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('69', 'Garrett Temple', '38', '28', '60', '18', '6', '28', '11', '12', '29', '31', '17', '2', '10', '53');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('70', 'Obi Toppin', '27', '79', '599', '317', '110', '301', '89', '114', '318', '128', '46', '28', '68', '833');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('71', 'Ja''Kobe Walter', '20', '52', '393', '159', '65', '186', '66', '83', '160', '81', '43', '10', '50', '449');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('72', 'Jaylen Wells', '21', '79', '676', '287', '138', '392', '111', '135', '268', '135', '44', '8', '69', '823');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('73', 'Derrick White', '30', '76', '959', '424', '265', '691', '135', '161', '341', '361', '72', '80', '131', '1248');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('74', 'Aaron Wiggins', '26', '76', '728', '355', '130', '339', '74', '89', '295', '134', '60', '18', '69', '914');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('75', 'Jalen Wilson', '24', '79', '620', '246', '122', '362', '135', '165', '270', '145', '40', '5', '79', '749');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('76', 'Trae Young', '26', '76', '1376', '566', '218', '642', '491', '561', '236', '880', '91', '12', '355', '1841');
INSERT INTO Player (PlayerID, PName, PlayerAge, GamesPlayed, FieldGoalAttempt, FieldGoalMade, ThreePointMade, ThreePointAttempt, FreeThrowMade, FreeThrowAttempt, Rebounds, Assists, Steals, Blocks, Turnovers, Points) VALUES ('77', 'Ivica Zubac', '28', '80', '942', '592', '0', '0', '156', '236', '1010', '214', '55', '90', '127', '1340');
INSERT INTO Teams (TeamID, TeamName) VALUES ('0' ,'Atlanta Hawks');
INSERT INTO Teams (TeamID, TeamName) VALUES ('1' ,'Boston Celtics');
INSERT INTO Teams (TeamID, TeamName) VALUES ('2' ,'Brooklyn Nets');
INSERT INTO Teams (TeamID, TeamName) VALUES ('3' ,'Charlotte Hornets');
INSERT INTO Teams (TeamID, TeamName) VALUES ('4' ,'Chicago Bulls');
INSERT INTO Teams (TeamID, TeamName) VALUES ('5' ,'Cleveland Cavaliers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('6' ,'Dallas Mavericks');
INSERT INTO Teams (TeamID, TeamName) VALUES ('7' ,'Denver Nuggets');
INSERT INTO Teams (TeamID, TeamName) VALUES ('8' ,'Detroit Pistons');
INSERT INTO Teams (TeamID, TeamName) VALUES ('9' ,'Golden State Warriors');
INSERT INTO Teams (TeamID, TeamName) VALUES ('10' ,'Houston Rockets');
INSERT INTO Teams (TeamID, TeamName) VALUES ('11' ,'Indiana Pacers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('12' ,'Los Angeles Clippers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('13' ,'Los Angeles Lakers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('14' ,'Memphis Grizzlies');
INSERT INTO Teams (TeamID, TeamName) VALUES ('15' ,'Miami Heat');
INSERT INTO Teams (TeamID, TeamName) VALUES ('16' ,'Milwaukee Bucks');
INSERT INTO Teams (TeamID, TeamName) VALUES ('17' ,'Minnesota Timberwolves');
INSERT INTO Teams (TeamID, TeamName) VALUES ('18' ,'New Orleans Pelicans');
INSERT INTO Teams (TeamID, TeamName) VALUES ('19' ,'New York Knicks');
INSERT INTO Teams (TeamID, TeamName) VALUES ('20' ,'Oklahoma City Thunder');
INSERT INTO Teams (TeamID, TeamName) VALUES ('21' ,'Orlando Magic');
INSERT INTO Teams (TeamID, TeamName) VALUES ('22' ,'Philadelphia 76ers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('23' ,'Phoenix Suns');
INSERT INTO Teams (TeamID, TeamName) VALUES ('24' ,'Portland Trail Blazers');
INSERT INTO Teams (TeamID, TeamName) VALUES ('25' ,'Sacramento Kings');
INSERT INTO Teams (TeamID, TeamName) VALUES ('26' ,'San Antonio Spurs');
INSERT INTO Teams (TeamID, TeamName) VALUES ('27' ,'Toronto Raptors');
INSERT INTO Teams (TeamID, TeamName) VALUES ('28' ,'Utah Jazz');
INSERT INTO Teams (TeamID, TeamName) VALUES ('29' ,'Washington Wizards');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('0', '15');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('1', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('2', '17');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('3', '5');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('4', '26');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('5', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('6', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('7', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('8', '12');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('9', '8');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('10', '21');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('11', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('12', '7');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('13', '19');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('14', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('15', '4');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('16', '21');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('17', '24');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('18', '29');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('19', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('20', '26');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('21', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('22', '26');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('23', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('24', '0');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('25', '25');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('26', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('27', '6');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('28', '8');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('29', '17');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('30', '25');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('31', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('32', '20');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('33', '10');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('34', '8');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('35', '12');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('36', '19');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('37', '15');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('38', '9');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('39', '8');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('40', '26');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('41', '2');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('42', '23');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('43', '12');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('44', '13');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('45', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('46', '9');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('47', '16');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('48', '11');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('49', '17');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('50', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('51', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('52', '25');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('53', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('54', '26');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('55', '4');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('56', '14');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('57', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('58', '7');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('59', '16');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('60', '1');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('61', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('62', '17');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('63', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('64', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('65', '10');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('66', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('67', '11');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('68', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('69', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('70', '11');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('71', '27');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('72', '14');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('73', '1');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('74', '20');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('75', '2');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('76', '0');
INSERT INTO HasPlayer (PlayerID, TeamID) VALUES ('77', '12');
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