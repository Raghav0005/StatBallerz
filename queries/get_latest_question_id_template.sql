SELECT QuestionID FROM Questions 
WHERE AuthorID = {{AUTHOR_ID}} AND QuestionText = '{{QUESTION_TEXT}}' AND QuestionType = '{{QUESTION_TYPE}}'
ORDER BY QuestionID DESC;
