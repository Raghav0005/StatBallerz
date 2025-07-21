SELECT u.Username
FROM Users u
WHERE u.Username != '{{USERNAME}}'
AND NOT EXISTS (
  SELECT *
  FROM QuizAttemptItems qi_cur
  JOIN QuizAttempts qa_cur ON qa_cur.AttemptID = qi_cur.AttemptID
  JOIN Users cu ON cu.UserID = qa_cur.UserID
  WHERE cu.Username = '{{USERNAME}}'
  AND NOT EXISTS (
    SELECT *
    FROM QuizAttemptItems qi_other
    JOIN QuizAttempts qa_other ON qa_other.AttemptID = qi_other.AttemptID
    WHERE qa_other.UserID = u.UserID AND qi_other.QuestionID = qi_cur.QuestionID
    )
  );
