SELECT 
    q.QuestionID,
    q.QuestionText,
    q.AuthorID,
    a.AnswerNumber,
    a.ResponseText,
    a.IsCorrect
FROM Questions q
JOIN Answers a ON q.QuestionID = a.QuestionID
WHERE q.QuestionID IN (
    SELECT QuestionID 
    FROM Questions 
    ORDER BY RANDOM() 
    LIMIT 7
)
ORDER BY RANDOM();