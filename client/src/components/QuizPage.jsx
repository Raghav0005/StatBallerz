import { useState } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { insertQuestion, fetchRandomQuiz } from "../api";

export default function QuizPage() {
  const { user } = useAuth();

  const [numQuestions, setNumQuestions] = useState(20);
  const [questions, setQuestions] = useState([]);
  const [form, setForm] = useState({
    question: "",
    options: ["", "", "", ""],
    answer: ""
  });
  const [quizStarted, setQuizStarted] = useState(false);
  const [userAnswers, setUserAnswers] = useState([]);
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [addingQuestion, setAddingQuestion] = useState(false); // New loading state for adding questions
  const [error, setError] = useState(null);

  if (!user) return <Navigate to="/" replace />;

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleOptionChange = (index, value) => {
    const updated = [...form.options];
    updated[index] = value;
    setForm({ ...form, options: updated });
  };

  const addQuestion = async () => {
    const { question, options, answer } = form;

    if (!question || question.trim() === "") {
      alert("Please enter a question.");
      return;
    }

    if (!options.every((opt) => opt.trim() !== "")) {
      alert("Please fill out all option fields.");
      return;
    }

    if (!answer || !options.includes(answer)) {
      alert("Please select a valid answer that matches one of the options.");
      return;
    }

    setAddingQuestion(true); // Start loading

    try {
      const answers = options.map((option) => ({
        text: option.trim(),
        isCorrect: option === answer
      }));

      const result = await insertQuestion(user.username, question.trim(), answers);

      if (result.error) {
        alert(`Error adding question: ${result.error}`);
      } else {
        setNumQuestions(numQuestions + 1);
        setForm({
          question: "",
          options: ["","","",""],
          answer: ""
        });
        alert("Question added successfully!");
      }
    } catch (error) {
      console.error("Unexpected error:", error);
      alert("An unexpected error occurred while adding the question.");
    } finally {
      setAddingQuestion(false); // Stop loading
    }
  };

  const startQuiz = async () => {
    setLoading(true);
    setError(null);

    try {
      const result = await fetchRandomQuiz();

      if (result.error) {
        setError(result.error);
        alert(`Error loading quiz: ${result.error}`);
        return;
      }

      const data = result.data;

      // Transform backend data to match frontend expectations
      const transformedQuestions = data.questions.map(q => ({
        questionId: q.questionId,
        question: q.questionText,
        options: q.answers.map(answer => answer.responseText),
        answer: q.answers.find(answer => answer.isCorrect)?.responseText || ""
      }));

      if (transformedQuestions.length === 0) {
        alert("No questions available in the database!");
        return;
      }

      setQuestions(transformedQuestions);
      setUserAnswers(Array(transformedQuestions.length).fill(""));
      setQuizStarted(true);
      setSubmitted(false);

      if (data.warning) {
        alert(`Warning: ${data.warning}`);
      }

    } catch (error) {
      console.error("Error fetching quiz:", error);
      setError(`Failed to load quiz: ${error.message}`);
      alert(`Failed to load quiz: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleAnswerChange = (index, value) => {
    const updated = [...userAnswers];
    updated[index] = value;
    setUserAnswers(updated);
  };

  const submitQuiz = () => {
    setSubmitted(true);
  };

  const calculateScore = () => {
    let correct = 0;
    questions.forEach((q, index) => {
      if (q.answer === userAnswers[index]) {
        correct++;
      }
    });
    return correct;
  };

  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <div className="max-w-2xl mx-auto mt-10 p-6 border rounded bg-white shadow space-y-6">
        <h1 className="text-2xl font-bold text-center">NBA Trivia Quiz</h1>

        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            {error}
          </div>
        )}

        <div className="text-center text-gray-700 font-medium">
          Question Bank: {numQuestions} {numQuestions === 1 ? "Total Question" : "Total Questions"}
        </div>

        {!quizStarted ? (
          <>
            {/* Create Question Form */}
            <div className="space-y-4">
              <input
                type="text"
                name="question"
                placeholder="Enter a question"
                value={form.question}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
                disabled={addingQuestion} // Disable input while adding
              />

              {/* Options */}
              {form.options.map((opt, index) => (
                <input
                  key={index}
                  type="text"
                  placeholder={`Option ${index + 1}`}
                  value={opt}
                  onChange={(e) => handleOptionChange(index, e.target.value)}
                  className="w-full border px-3 py-2 rounded"
                  disabled={addingQuestion} // Disable input while adding
                />
              ))}
              <input
                type="text"
                name="answer"
                placeholder="Enter the correct answer (must match one of the options)"
                value={form.answer}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
                disabled={addingQuestion} // Disable input while adding
              />

              <button
                onClick={addQuestion}
                disabled={addingQuestion} // Disable button while adding
                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:bg-blue-300 disabled:cursor-not-allowed"
              >
                {addingQuestion ? "Adding Question..." : "Add Question"}
              </button>
            </div>

            {/* Start Quiz */}
            <div className="pt-6 text-center">
              <button
                onClick={startQuiz}
                disabled={loading}
                className="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700 disabled:bg-green-300 disabled:cursor-not-allowed"
              >
                {loading ? "Loading Quiz..." : "Start Quiz"}
              </button>
              <p className="text-sm text-gray-600 mt-2">
                This will load random questions from the database
              </p>
            </div>
          </>
        ) : (
          <>
            {!submitted ? (
              <>
                <h2 className="text-xl font-semibold">Answer the questions:</h2>
                {questions.map((q, index) => (
                  <div key={q.questionId || index} className="mb-6 p-4 bg-gray-50 rounded">
                    <p className="font-medium mb-3">Q{index + 1}: {q.question}</p>
                    <div className="space-y-2">
                      {q.options.map((option, i) => (
                        <label key={i} className="flex items-center cursor-pointer hover:bg-gray-100 p-2 rounded">
                          <input
                            type="radio"
                            name={`question-${index}`}
                            value={option}
                            checked={userAnswers[index] === option}
                            onChange={() => handleAnswerChange(index, option)}
                            className="mr-3"
                          />
                          <span>{option}</span>
                        </label>
                      ))}
                    </div>
                  </div>
                ))}
                <div className="text-center">
                  <button
                    onClick={submitQuiz}
                    className="bg-blue-700 text-white px-6 py-2 rounded hover:bg-blue-800"
                  >
                    Submit Answers
                  </button>
                </div>
              </>
            ) : (
              <>
                <div className="text-center mb-6">
                  <h2 className="text-xl font-semibold">Quiz Results</h2>
                  <div className="mt-2 text-lg">
                    Score: <span className="font-bold text-green-600">
                      {calculateScore()}/{questions.length}
                    </span>
                    <span className="text-gray-600 ml-2">
                      ({Math.round((calculateScore() / questions.length) * 100)}%)
                    </span>
                  </div>
                </div>

                <div className="space-y-4">
                  {questions.map((q, index) => {
                    const isCorrect = q.answer === userAnswers[index];
                    return (
                      <div key={q.questionId || index} className="border p-4 rounded-lg">
                        <p className="font-medium mb-2">Q{index + 1}: {q.question}</p>

                        <div className="mb-2">
                          <span className="font-semibold">Your answer: </span>
                          <span className={isCorrect ? "text-green-600 font-medium" : "text-red-600 font-medium"}>
                            {userAnswers[index] || "No answer selected"}
                            {isCorrect ? " ✓" : " ✗"}
                          </span>
                        </div>

                        {!isCorrect && (
                          <div className="mb-2">
                            <span className="font-semibold">Correct answer: </span>
                            <span className="text-green-600 font-medium">{q.answer}</span>
                          </div>
                        )}

                        <div className="text-sm text-gray-600 mt-2">
                          <strong>All options:</strong> {q.options.join(", ")}
                        </div>
                      </div>
                    );
                  })}
                </div>

                <div className="text-center">
                  <button
                    onClick={() => {
                      setQuizStarted(false);
                      setSubmitted(false);
                      setUserAnswers([]);
                      setQuestions([]);
                      setError(null);
                    }}
                    className="bg-gray-700 text-white px-6 py-2 rounded hover:bg-gray-800"
                  >
                    Restart
                  </button>
                </div>
              </>
            )}
          </>
        )}
      </div>
    </div>
  );
}