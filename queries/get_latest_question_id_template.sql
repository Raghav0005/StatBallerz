SELECT QuestionID FROM Questions 
WHERE AuthorID = {{AUTHOR_ID}} AND QuestionText = '{{QUESTION_TEXT}}'
ORDER BY QuestionID DESC;
