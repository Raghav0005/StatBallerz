import { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { insertQuestion, fetchRandomQuiz, submitQuizAttempt, fetchQuestionCount, fetchAllPlayers, fetchAllTeams } from "../api";

export default function QuizPage() {
  const { user } = useAuth();

  const [numQuestions, setNumQuestions] = useState(-1);
  const [questions, setQuestions] = useState([]);
  const [form, setForm] = useState({
    question: "",
    questionType: "player", // Default to player type
    options: ["", "", "", ""],
    answer: ""
  });
  const [quizStarted, setQuizStarted] = useState(false);
  const [userAnswers, setUserAnswers] = useState([]);
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [addingQuestion, setAddingQuestion] = useState(false);
  const [submittingQuiz, setSubmittingQuiz] = useState(false);
  const [error, setError] = useState(null);
  
  // Local storage for player and team names
  const [playerNames, setPlayerNames] = useState(new Set());
  const [teamNames, setTeamNames] = useState(new Set());
  const [namesLoaded, setNamesLoaded] = useState(false);

  useEffect(() => {
    const loadData = async () => {
      try {
        // Load question count
        const questionCountResult = await fetchQuestionCount();
        if (questionCountResult.error) {
          console.error("Error fetching question count:", questionCountResult.error);
          setError(`Error loading question count: ${questionCountResult.error}`);
        } else {
          setNumQuestions(questionCountResult.data.count);
          console.log(questionCountResult.data.count);
        }

        // Load all player names
        const playersResult = await fetchAllPlayers();
        if (playersResult.error) {
          console.error("Error fetching players:", playersResult.error);
          setError(`Error loading players: ${playersResult.error}`);
        } else {
          // Format names with proper capitalization (First Last)
          const playerSet = new Set(playersResult.data.players.map(name => 
            name.toLowerCase().split(' ').map(word => 
              word.charAt(0).toUpperCase() + word.slice(1)
            ).join(' ')
          ));
          setPlayerNames(playerSet);
          console.log("Loaded players:", playersResult.data.players.length);
          console.log(playerSet);
        }

        // Load all team names
        const teamsResult = await fetchAllTeams();
        if (teamsResult.error) {
          console.error("Error fetching teams:", teamsResult.error);
          setError(`Error loading teams: ${teamsResult.error}`);
        } else {
          // Format names with proper capitalization (First Last)
          const teamSet = new Set(teamsResult.data.teams.map(name => 
            name.toLowerCase().split(' ').map(word => 
              word.charAt(0).toUpperCase() + word.slice(1)
            ).join(' ')
          ));
          setTeamNames(teamSet);
          console.log("Loaded teams:", teamsResult.data.teams.length);
        }

        setNamesLoaded(true);
      } catch (error) {
        console.error("Error loading data:", error);
        setError(`Failed to load data: ${error.message}`);
      }
    };
    loadData();
  }, []);

  if (!user) return <Navigate to="/" replace />;

  // Function to shuffle an array
  const shuffleArray = (array) => {
    const newArray = [...array];
    for (let i = newArray.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
    }
    return newArray;
  };

  // Function to validate if a name exists in the appropriate set
  const validateName = (name, questionType) => {
    console.log(`Validating name: ${name} for type: ${questionType}`);
    // Format the input name to proper capitalization for comparison
    const formattedName = name.trim().toLowerCase().split(' ').map(word => 
      word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
    console.log(`Validating formatted name: ${formattedName} for type: ${questionType}`);
    if (questionType === "player") {
      return playerNames.has(formattedName);
    } else if (questionType === "team") {
      return teamNames.has(formattedName);
    }
    return false;
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleOptionChange = (index, value) => {
    const updated = [...form.options];
    updated[index] = value;
    setForm({ ...form, options: updated });
  };

  // Function to validate that all options are unique
  const validateUniqueOptions = (options) => {
    const trimmedOptions = options.map(opt => opt.trim().toLowerCase());
    const uniqueOptions = new Set(trimmedOptions);
    return uniqueOptions.size === options.length;
  };

  // Function to check for duplicate options and return details
  const findDuplicateOptions = (options) => {
    const trimmedOptions = options.map(opt => opt.trim().toLowerCase());
    const seen = new Set();
    const duplicates = new Set();
    
    trimmedOptions.forEach(option => {
      if (seen.has(option)) {
        duplicates.add(option);
      } else {
        seen.add(option);
      }
    });
    
    return Array.from(duplicates);
  };

  const addQuestion = async () => {
    const { question, questionType, options, answer } = form;

    if (!namesLoaded) {
      alert("Player and team names are still loading. Please wait a moment and try again.");
      return;
    }

    if (!question || question.trim() === "") {
      alert("Please enter a question.");
      return;
    }

    if (!options.every((opt) => opt.trim() !== "")) {
      alert("Please fill out all option fields.");
      return;
    }

    // Check for unique options
    if (!validateUniqueOptions(options)) {
      const duplicates = findDuplicateOptions(options);
      alert(`All answer options must be unique. Duplicate options found: ${duplicates.join(", ")}`);
      return;
    }

    if (!answer || answer.trim() === "") {
      alert("Please enter the correct answer.");
      return;
    }

    // Check if the correct answer matches one of the options (case-insensitive)
    const trimmedAnswer = answer.trim().toLowerCase();
    const trimmedOptions = options.map(opt => opt.trim().toLowerCase());
    
    if (!trimmedOptions.includes(trimmedAnswer)) {
      alert("The correct answer must exactly match one of the four options.");
      return;
    }

    // Validate names in options and answer fields
    const invalidNames = [];
    
    // Check each option
    for (const option of options) {
      if (!validateName(option, questionType)) {
        invalidNames.push(option.trim());
      }
    }
    
    // Check the answer
    if (!validateName(answer, questionType)) {
      invalidNames.push(answer.trim());
    }
    
    if (invalidNames.length > 0) {
      const entityType = questionType === "player" ? "players" : "teams";
      alert(`Error: The following ${entityType} were not found in the database: ${[...new Set(invalidNames)].join(", ")}. Please verify the names are correct before adding the question.`);
      return;
    }

    setAddingQuestion(true);

    try {
      // Format names to proper capitalization before inserting
      const formatName = (name) => {
        return name.trim().toLowerCase().split(' ').map(word => 
          word.charAt(0).toUpperCase() + word.slice(1)
        ).join(' ');
      };

      const answers = options.map((option) => ({
        text: formatName(option),
        isCorrect: option.trim().toLowerCase() === trimmedAnswer
      }));

      const result = await insertQuestion(user.username, question.trim(), form.questionType, answers);

      if (result.error) {
        alert(`Error adding question: ${result.error}`);
      } else {
        setNumQuestions(numQuestions + 1);
        setForm({
          question: "",
          questionType: "player",
          options: ["","","",""],
          answer: ""
        });
        alert("Question added successfully!");
      }
    } catch (error) {
      console.error("Unexpected error:", error);
      alert("An unexpected error occurred while adding the question.");
    } finally {
      setAddingQuestion(false);
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
      const transformedQuestions = data.questions.map((q, qIndex) => {
        console.log(`=== QUESTION ${qIndex + 1} ===`);
        console.log('Raw question data:', q);
        
        // Find the correct answer - it should have isCorrect === "1"
        const correctAnswer = q.answers.find(answer => answer.isCorrect === "1");
        
        console.log('Found correct answer:', correctAnswer);
        
        // Extract all options and shuffle them
        const allOptions = q.answers.map(answer => answer.responseText);
        const shuffledOptions = shuffleArray(allOptions);
        
        const transformedQuestion = {
          questionId: q.questionId,
          question: q.questionText,
          options: shuffledOptions,
          answer: correctAnswer ? correctAnswer.responseText : "NO CORRECT ANSWER FOUND"
        };
        
        console.log('Transformed question:', transformedQuestion);
        console.log('=================\n');
        
        return transformedQuestion;
      });

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

  const submitQuiz = async () => {
    setSubmittingQuiz(true);
    
    try {
      const result = await submitQuizAttempt(user.username, questions, userAnswers);
      
      if (result.error) {
        alert(`Error submitting quiz: ${result.error}`);
      } else {
        setSubmitted(true);
        console.log("Quiz attempt saved successfully");
      }
    } catch (error) {
      console.error("Error submitting quiz:", error);
      alert(`Failed to submit quiz: ${error.message}`);
    } finally {
      setSubmittingQuiz(false);
    }
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

        {!namesLoaded && (
          <div className="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded">
            Loading player and team data for validation...
          </div>
        )}

        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            {error}
          </div>
        )}

        {/* <div className="text-center text-gray-700 font-medium">
          Question Bank: {numQuestions === -1 ? "Loading..." : `${numQuestions} Total Questions`}
        </div> */}

        {!quizStarted ? (
          <>
            {/* Create Question Form */}
            <div className="text-sm text-gray-600 bg-blue-50 p-3 rounded">
              <p><strong>Requirements:</strong></p>
              <ul className="list-disc list-inside mt-1 space-y-1">
                <li>All 4 answer options must be unique</li>
                <li>The correct answer must exactly match one of the 4 options</li>
                <li>Matching is case-insensitive</li>
              </ul>
            </div>

            <div className="space-y-4">
              <input
                type="text"
                name="question"
                placeholder="Enter a question"
                value={form.question}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
                disabled={addingQuestion || !namesLoaded}
              />

              <select
                name="questionType"
                value={form.questionType}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
                disabled={addingQuestion || !namesLoaded}
              >
                <option value="player">Player Question</option>
                <option value="team">Team Question</option>
              </select>
              
              <div className="text-sm text-gray-600 mt-1">
                {form.questionType === "player" 
                  ? `Create a question about NBA players. Player names will be validated against ${playerNames.size} known players.`
                  : `Create a question about NBA teams. Team names will be validated against ${teamNames.size} known teams.`
                }
              </div>

              {/* Options */}
              {form.options.map((opt, index) => (
                <input
                  key={index}
                  type="text"
                  placeholder={`Option ${index + 1}`}
                  value={opt}
                  onChange={(e) => handleOptionChange(index, e.target.value)}
                  className="w-full border px-3 py-2 rounded"
                  disabled={addingQuestion || !namesLoaded}
                />
              ))}
              <input
                type="text"
                name="answer"
                placeholder="Enter the correct answer (must match one of the options exactly)"
                value={form.answer}
                onChange={handleChange}
                className="w-full border px-3 py-2 rounded"
                disabled={addingQuestion || !namesLoaded}
              />

              <button
                onClick={addQuestion}
                disabled={addingQuestion || !namesLoaded}
                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:bg-blue-300 disabled:cursor-not-allowed"
              >
                {addingQuestion ? "Adding Question..." : !namesLoaded ? "Loading Names..." : "Add Question"}
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
                    disabled={submittingQuiz}
                    className="bg-blue-700 text-white px-6 py-2 rounded hover:bg-blue-800 disabled:bg-blue-300 disabled:cursor-not-allowed"
                  >
                    {submittingQuiz ? "Submitting..." : "Submit Answers"}
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