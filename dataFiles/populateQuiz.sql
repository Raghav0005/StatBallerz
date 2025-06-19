-- 1. Total Points Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who scored the most total points in the 2024–2025 regular season?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 4, 'Anthony Edwards', FALSE);

-- 2. Points Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who led the league in points per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 3, 'Luka Dončić', FALSE),
(LASTVAL(), 4, 'Donovan Mitchell', FALSE);

-- 3. Total Rebounds Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the most total rebounds in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Domantas Sabonis', TRUE),
(LASTVAL(), 2, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 3, 'Nikola Jokić', FALSE),
(LASTVAL(), 4, 'Alperen Şengün', FALSE);

-- 4. Rebounds Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most rebounds per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Domantas Sabonis', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Karl‑Anthony Towns', FALSE),
(LASTVAL(), 4, 'Jayson Tatum', FALSE);

-- 5. Total Assists Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who recorded the most total assists in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Tyrese Haliburton', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Shai Gilgeous‑Alexander', FALSE),
(LASTVAL(), 4, 'James Harden', FALSE);

-- 6. Assists Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most assists per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Trae Young', TRUE),
(LASTVAL(), 2, 'Tyrese Haliburton', FALSE),
(LASTVAL(), 3, 'Nikola Jokić', FALSE),
(LASTVAL(), 4, 'James Harden', FALSE);

-- 7. Triple-Double Total Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who recorded the most triple-doubles in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Nikola Jokić', TRUE),
(LASTVAL(), 2, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 3, 'LeBron James', FALSE),
(LASTVAL(), 4, 'Domantas Sabonis', FALSE);

-- 8. Steals Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most steals per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Dyson Daniels', TRUE),
(LASTVAL(), 2, 'Jayson Tatum', FALSE),
(LASTVAL(), 3, 'LeBron James', FALSE),
(LASTVAL(), 4, 'Nikola Jokić', FALSE);

-- 9. Blocks Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most blocks per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Victor Wembanyama', TRUE),
(LASTVAL(), 2, 'Myles Turner', FALSE),
(LASTVAL(), 3, 'Isaiah Stewart', FALSE),
(LASTVAL(), 4, 'Chet Holmgren', FALSE);

-- 10. Free Throw Percentage Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the highest free-throw percentage (qualifying) in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Stephen Curry', TRUE),
(LASTVAL(), 2, 'Jarrett Allen', FALSE),
(LASTVAL(), 3, 'Seth Curry', FALSE),
(LASTVAL(), 4, 'Tyler Burns', FALSE);

-- 11. Field Goal Percentage Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the highest field-goal percentage (qualifying) in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Jarrett Allen', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Victor Wembanyama', FALSE),
(LASTVAL(), 4, 'Stephen Curry', FALSE);

-- 12. 3-Point Percentage Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the highest 3‑point percentage (qualifying) in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Seth Curry', TRUE),
(LASTVAL(), 2, 'Stephen Curry', FALSE),
(LASTVAL(), 3, 'Derrick White', FALSE),
(LASTVAL(), 4, 'Jayson Tatum', FALSE);

-- 13. Minutes Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most minutes per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Josh Hart', TRUE),
(LASTVAL(), 2, 'Cade Cunningham', FALSE),
(LASTVAL(), 3, 'LeBron James', FALSE),
(LASTVAL(), 4, 'Luka Dončić', FALSE);

-- 14. Turnovers Per Game Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who averaged the most turnovers per game in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Trae Young', TRUE),
(LASTVAL(), 2, 'Shai Gilgeous‑Alexander', FALSE),
(LASTVAL(), 3, 'Nikola Jokić', FALSE),
(LASTVAL(), 4, 'James Harden', FALSE);

-- 15. Double-Doubles Total Leader
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who recorded the most double-doubles in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Domantas Sabonis', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 4, 'Jayson Tatum', FALSE);

-- 16. MVP of the Season
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who was named MVP of the 2024–2025 NBA season?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Nikola Jokić', FALSE),
(LASTVAL(), 3, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 4, 'Luka Dončić', FALSE);

-- 17. Most 50-Point Games
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the most 50‑point games in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Kevin Durant', FALSE),
(LASTVAL(), 3, 'Luka Dončić', FALSE),
(LASTVAL(), 4, 'Devin Booker', FALSE);

-- 18. Triple-Doubles in Playoffs
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the most triple‑doubles in the 2025 playoffs?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Nikola Jokić', TRUE),
(LASTVAL(), 2, 'Giannis Antetokounmpo', FALSE),
(LASTVAL(), 3, 'Tyrese Haliburton', FALSE),
(LASTVAL(), 4, 'Josh Hart', FALSE);

-- 19. Canadian Leading Scorer
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who became the first Canadian to lead the NBA in scoring?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Andrew Wiggins', FALSE),
(LASTVAL(), 3, 'Kelly Olynyk', FALSE),
(LASTVAL(), 4, 'Jamal Murray', FALSE);

-- 20. Longest 20‑Point Streak
INSERT INTO Questions (AuthorID, QuestionText) VALUES
(1, 'Who had the longest streak of 20‑point games in 2024–2025?');
INSERT INTO Answers (QuestionID, AnswerNumber, ResponseText, IsCorrect) VALUES
(LASTVAL(), 1, 'Shai Gilgeous‑Alexander', TRUE),
(LASTVAL(), 2, 'Kevin Durant', FALSE),
(LASTVAL(), 3, 'Luka Dončić', FALSE),
(LASTVAL(), 4, 'Michael Jordan', FALSE);