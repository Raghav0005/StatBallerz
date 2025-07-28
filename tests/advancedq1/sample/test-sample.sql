WITH FullyCorrectAttempts AS (
    SELECT qa.AttemptID, u.UserID, u.Username, COUNT(*) AS QuestionsCorrect
    FROM QuizAttemptItems qai
    JOIN QuizAttempts qa ON qai.AttemptID = qa.AttemptID
    JOIN Users u ON qa.UserID = u.UserID
    JOIN Answers a ON qai.QuestionID = a.QuestionID AND qai.AnswerNumber = a.AnswerNumber
    WHERE a.IsCorrect = TRUE
    GROUP BY qa.AttemptID, u.UserID, u.Username
    HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM QuizAttemptItems qai2
        WHERE qai2.AttemptID = qa.AttemptID
    )
)
SELECT fca.Username, fca.QuestionsCorrect,
    (
      SELECT COUNT(DISTINCT lb2.MaxScore)
      FROM LEADERBOARD lb2
      WHERE lb2.MaxScore > lb.MaxScore
    ) + 1 AS LeaderboardRank
FROM FullyCorrectAttempts fca
JOIN LEADERBOARD lb ON fca.Username = lb.Username
ORDER BY lb.MaxScore DESC, fca.QuestionsCorrect DESC;
