import { useState } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";


export default function QuizPage() {
  const { user } = useAuth();
  if (!user) return <Navigate to="/" replace />;


  const [questions, setQuestions] = useState([]);
  const [form, setForm] = useState({
    question: "",
    options: ["", "", "", ""],
    answer: ""
  });
  const [quizStarted, setQuizStarted] = useState(false);
  const [userAnswers, setUserAnswers] = useState([]);
  const [submitted, setSubmitted] = useState(false);


  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };


  const handleOptionChange = (index, value) => {
    const updated = [...form.options];
    updated[index] = value;
    setForm({ ...form, options: updated });
  };


  const addQuestion = () => {
    const { question, options, answer } = form;
    if (
      question &&
      options.every((opt) => opt.trim() !== "") &&
      options.includes(answer)
    ) {
      setQuestions([...questions, { question, options, answer }]);
      setForm({
        question: "",
        options: ["", "", "", ""],
        answer: ""
      });
    } else {
      alert("Please fill out all fields and ensure the answer matches one of the options.");
    }
  };


  const startQuiz = () => {
    if (questions.length === 0) {
      alert("Please add at least one question!");
      return;
    }
    setUserAnswers(Array(questions.length).fill(""));
    setQuizStarted(true);
    setSubmitted(false);
  };


  const handleAnswerChange = (index, value) => {
    const updated = [...userAnswers];
    updated[index] = value;
    setUserAnswers(updated);
  };


  const submitQuiz = () => {
    setSubmitted(true);
  };


  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <div className="max-w-2xl mx-auto mt-10 p-6 border rounded bg-white shadow space-y-6">
        <h1 className="text-2xl font-bold text-center">NBA Trivia Quiz</h1>
        <div className="text-center text-gray-700 font-medium">
          Question Bank: {questions.length} {questions.length === 1 ? "Total Question" : "Total Questions"}
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
              />
              {form.options.map((opt, index) => (
                <input
                  key={index}
                  type="text"
                  placeholder={`Option ${index + 1}`}
                  value={opt}
                  onChange={(e) => handleOptionChange(index, e.target.value)}
                  className="w-full border px-3 py-2 rounded"
                />
              ))}
              <input
                type="text"
                name="answer"
                placeholder="Enter the correct answer (must match one of the options)"
                value={form.answer}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
              />
              <button
                onClick={addQuestion}
                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
              >
                Add Question
              </button>
            </div>


            {/* Start Quiz */}
            <div className="pt-6 text-center">
              <button
                onClick={startQuiz}
                className="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700"
              >
                Start Quiz
              </button>
            </div>
          </>
        ) : (
          <>
            {!submitted ? (
              <>
                <h2 className="text-xl font-semibold">Answer the questions:</h2>
                {questions.map((q, index) => (
                  <div key={index} className="mb-6">
                    <p className="font-medium">Q{index + 1}: {q.question}</p>
                    {q.options.map((option, i) => (
                      <label key={i} className="block mt-2">
                        <input
                          type="radio"
                          name={`question-${index}`}
                          value={option}
                          checked={userAnswers[index] === option}
                          onChange={() => handleAnswerChange(index, option)}
                          className="mr-2"
                        />
                        {option}
                      </label>
                    ))}
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
                <h2 className="text-xl font-semibold">Results:</h2>
                {questions.map((q, index) => {
                  const isCorrect = q.answer === userAnswers[index];
                  return (
                    <div key={index} className="mb-6 border p-4 rounded">
                      <p className="font-medium">Q{index + 1}: {q.question}</p>
                      <p className="mt-1">
                        <span className="font-semibold">Your answer:</span>{" "}
                        <span className={isCorrect ? "text-green-600" : "text-red-600"}>
                          {userAnswers[index] || "No answer selected"}
                        </span>
                      </p>
                      <p className="mt-1">
                        <span className="font-semibold">Correct answer:</span> {q.answer}
                      </p>
                    </div>
                  );
                })}
                <div className="text-center">
                  <button
                    onClick={() => {
                      setQuizStarted(false);
                      setSubmitted(false);
                      setUserAnswers([]);
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
