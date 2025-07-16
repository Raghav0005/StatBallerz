-- Find all users who have answered every question that the current logged in user has answered
SELECT DISTINCT u.Username
FROM Users u
WHERE NOT EXISTS (
    -- Questions that the current user has answered
    SELECT qa1.QuestionID
    FROM QuizAttempts qa1
    JOIN QuizAttemptItems qai1 ON qa1.AttemptID = qai1.AttemptID
    JOIN Users u1 ON qa1.UserID = u1.UserID
    WHERE u1.Username = '{{USERNAME}}'
    
    EXCEPT
    
    -- Questions that user u has answered
    SELECT qa2.QuestionID
    FROM QuizAttempts qa2
    JOIN QuizAttemptItems qai2 ON qa2.AttemptID = qai2.AttemptID
    WHERE qa2.UserID = u.UserID
)
-- Exclude the current user from results
AND u.Username != '{{USERNAME}}'