import { useState, useEffect } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import { getAnsweredAllQuestionsAsUser, getAnsweredAllCorrectSingleAttempt } from "../api";

export default function SpecialQueriesPage() {
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }

  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedQuery, setSelectedQuery] = useState("");

  const queryOptions = [
    {
      value: "division",
      label: "Division Query: Users Who Answered All Your Questions",
      description: "This query finds all users who have answered every question that you have answered in quizzes."
    },
    {
      value: "all-correct-single",
      label: "Perfect Single Attempt: Users Who Got All Questions Correct in a Single Attempt",
      description: "This query finds all users who answered all questions correctly in a single quiz attempt."
    }
  ];

  // Automatically run query when selection changes
  useEffect(() => {
    const runQuery = async () => {
      if (!selectedQuery) {
        setResults([]);
        return;
      }
      
      setLoading(true);
      setResults([]); // Clear previous results
      
      try {
        if (selectedQuery === "division") {
          const data = await getAnsweredAllQuestionsAsUser(user.username);
          if (data.error) {
            alert(`❌ Query failed: ${data.error}`);
            return;
          }

          if (data.results.length > 0) {
            setResults(data.results);
          } else {
            alert("❌ No users found who have answered all the same questions as you.");
            setResults([]);
          }
        } else if (selectedQuery === "all-correct-single") {
          const data = await getAnsweredAllCorrectSingleAttempt();
          if (data.error) {
            alert(`❌ Query failed: ${data.error}`);
            return;
          }

          if (data.results.length > 0) {
            setResults(data.results);
          } else {
            alert("❌ No users found who answered all questions correctly in a single attempt.");
            setResults([]);
          }
        }
      } catch (err) {
        console.error("Query error:", err);
        alert("❌ An error occurred while running the query. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    runQuery();
  }, [selectedQuery, user.username]);

  const handleQueryChange = (newQuery) => {
    setResults([]); // Clear results immediately when changing query
    setSelectedQuery(newQuery);
  };

  const getResultHeaders = () => {
    if (selectedQuery === "division") {
      return ["Username"];
    } else if (selectedQuery === "all-correct-single") {
      return ["Username", "Questions Correct", "Leaderboard Rank"];
    }
    return [];
  };

  const renderResultRow = (result, idx) => {
    if (selectedQuery === "division") {
      return (
        <tr key={idx} className="bg-white border-t hover:bg-gray-50">
          <td className="p-4">{result.USERNAME || result.Username}</td>
        </tr>
      );
    } else if (selectedQuery === "all-correct-single") {
      return (
        <tr key={idx} className="bg-white border-t hover:bg-gray-50">
          <td className="p-4">{result.USERNAME || result.Username}</td>
          <td className="p-4">{result.QUESTIONSCORRECT || result.QuestionsCorrect}</td>
          <td className="p-4">{result.LEADERBOARDRANK || result.LeaderboardRank}</td>
        </tr>
      );
    }
    return null;
  };

  const getResultTitle = () => {
    if (selectedQuery === "division") {
      return `Users Who Have Answered All Your Questions (${results.length} found)`;
    } else if (selectedQuery === "all-correct-single") {
      return `Users Who Got All Questions Correct in Single Attempt (${results.length} found)`;
    }
    return "Query Results";
  };

  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <section className="max-w-4xl mx-auto mt-8 px-6">
        <h1 className="text-3xl font-bold text-gray-800 mb-8 text-center">Special Queries</h1>
        
        <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
          <h2 className="text-xl font-semibold text-gray-700 mb-4">
            Select a Query to Run
          </h2>
          
          <div className="mb-4">
            <label htmlFor="query-select" className="block text-sm font-medium text-gray-700 mb-2">
              Choose Query:
            </label>
            <select
              id="query-select"
              value={selectedQuery}
              onChange={(e) => handleQueryChange(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              disabled={loading}
            >
              <option value="">-- Select a query --</option>
              {queryOptions.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>

          {selectedQuery && (
            <div className="mb-4 p-4 bg-blue-50 rounded-lg border border-blue-200">
              <p className="text-blue-800 text-sm">
                <strong>Description:</strong> {queryOptions.find(q => q.value === selectedQuery)?.description}
              </p>
              {loading && (
                <p className="text-blue-600 text-sm mt-2 font-medium">
                  🔄 Running query...
                </p>
              )}
            </div>
          )}
        </div>
      </section>

      <main className="max-w-4xl mx-auto mt-8 px-6">
        {results.length > 0 ? (
          <div className="bg-white rounded-lg shadow-lg overflow-hidden">
            <div className="bg-gray-200 px-6 py-4">
              <h3 className="text-lg font-semibold text-gray-800">
                {getResultTitle()}
              </h3>
            </div>
            <div className="overflow-auto">
              <table className="w-full text-sm text-left text-gray-700">
                <thead className="bg-gray-100 text-gray-900 font-semibold">
                  <tr>
                    {getResultHeaders().map((header, idx) => (
                      <th key={idx} className="p-4">{header}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {results.map((result, idx) => renderResultRow(result, idx))}
                </tbody>
              </table>
            </div>
          </div>
        ) : (
          <div className="bg-white rounded-lg shadow-lg p-8 text-center">
            <p className="text-gray-600">
              {loading
                ? "🔄 Running query, please wait..."
                : selectedQuery 
                  ? "Query completed. No results found."
                  : "Select a query from the dropdown above to get started."
              }
            </p>
          </div>
        )}
      </main>
    </div>
  );
}
