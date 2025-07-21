import { useState, useEffect } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import {
  getAnsweredAllQuestionsAsUser,
  getAnsweredAllCorrectSingleAttempt,
  getPlayerStatsIntersection
} from "../api";

export default function SpecialQueriesPage() {
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }

  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedQuery, setSelectedQuery] = useState("");
  // Intersection inputs
  const [player1, setPlayer1] = useState("");
  const [player2, setPlayer2] = useState("");
  const statOptions = [
    'TotalPoints','AveragePoints','TotalAssists','AverageAssists',
    'TotalRebounds','AverageRebounds','TotalBlocks','AverageBlocks'
  ];
  const [stat1, setStat1] = useState(statOptions[0]);
  const [stat2, setStat2] = useState(statOptions[0]);

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
    ,{
      value: "intersection",
      label: "Player Stats Intersection",
      description: "Find players with stats >= two selected players on two chosen stats. Enter both first and last name (names will be auto-formatted to Title Case)."
    }
  ];

  // Automatically run query when selection changes
  useEffect(() => {
    // auto-run non-intersection queries
    const runQuery = async () => {
      if (!selectedQuery || selectedQuery === 'intersection') {
        setResults([]);
        return;
      }
      setLoading(true);
      setResults([]);
      try {
        if (selectedQuery === "division") {
          const data = await getAnsweredAllQuestionsAsUser(user.username);
          if (data.error) { alert(`❌ Query failed: ${data.error}`); return; }
          data.results.length ? setResults(data.results) : alert("❌ No users found who have answered all the same questions as you.");
        } else if (selectedQuery === "all-correct-single") {
          const data = await getAnsweredAllCorrectSingleAttempt();
          if (data.error) { alert(`❌ Query failed: ${data.error}`); return; }
          data.results.length ? setResults(data.results) : alert("❌ No users found who answered all questions correctly in a single attempt.");
        }
      } catch (err) {
        console.error("Query error:", err);
        alert("❌ An error occurred while running the query. Please try again.");
      } finally { setLoading(false); }
    };

    runQuery();
  }, [selectedQuery, user.username]);

  // Helper function to validate player name has first and last name
  const isValidPlayerName = (name) => {
    const trimmed = name.trim();
    const words = trimmed.split(/\s+/);
    return words.length >= 2 && words.every(word => word.length > 0);
  };

  const handleQueryChange = (newQuery) => {
    setResults([]); // Clear results immediately when changing query
    setSelectedQuery(newQuery);
  };
  
  // Handler for intersection query
  const runIntersection = async () => {
    // Validate that both names have at least first and last name
    const validateName = (name) => {
      const trimmed = name.trim();
      const words = trimmed.split(/\s+/);
      return words.length >= 2 && words.every(word => word.length > 0);
    };

    if (!validateName(player1)) {
      alert("❌ Player 1 must include both first and last name (e.g., 'LeBron James')");
      return;
    }

    if (!validateName(player2)) {
      alert("❌ Player 2 must include both first and last name (e.g., 'Stephen Curry')");
      return;
    }

    setLoading(true);
    setResults([]);
    try {
      const data = await getPlayerStatsIntersection(player1, stat1, player2, stat2);
      if (data.error) {
        alert(`❌ Query failed: ${data.error}`);
        return;
      }
      if (data.results.length > 0) {
        setResults(data.results);
      } else {
        alert("❌ No players found matching the criteria.");
        setResults([]);
      }
    } catch (err) {
      console.error("Intersection query error:", err);
      alert("❌ An error occurred while running the intersection query.");
    } finally {
      setLoading(false);
    }
  };

  const getResultHeaders = () => {
    if (selectedQuery === "division") {
      return ["Username"];
    } else if (selectedQuery === "all-correct-single") {
      return ["Username", "Questions Correct", "Leaderboard Rank"];
    } else if (selectedQuery === "intersection") {
      return ["Player ID", "Player Name"];
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
    } else if (selectedQuery === "intersection") {
      return (
        <tr key={idx} className="bg-white border-t hover:bg-gray-50">
          <td className="p-4">{result.PLAYERID || result.PlayerID}</td>
          <td className="p-4">{result.PNAME || result.PName}</td>
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
    } else if (selectedQuery === "intersection") {
      return `Players with ${stat1} >= Player ${player1} AND ${stat2} >= Player ${player2} (${results.length} found)`;
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
              {selectedQuery === 'intersection' && (
                <div className="mt-4 space-y-4">
                                    <div className="flex space-x-2">
                    <input
                      type="text"
                      placeholder="Player 1 (First Last - e.g., lebron james)"
                      value={player1}
                      onChange={(e) => setPlayer1(e.target.value)}
                      className="w-1/2 px-2 py-1 border rounded"
                    />
                    <select
                      value={stat1}
                      onChange={(e) => setStat1(e.target.value)}
                      className="w-1/2 px-2 py-1 border rounded"
                    >
                      {statOptions.map((s) => (<option key={s} value={s}>{s}</option>))}
                    </select>
                  </div>
                  <div className="flex space-x-2">
                    <input
                      type="text"
                      placeholder="Player 2 (First Last - e.g., stephen curry)"
                      value={player2}
                      onChange={(e) => setPlayer2(e.target.value)}
                      className="w-1/2 px-2 py-1 border rounded"
                    />
                    <select
                      value={stat2}
                      onChange={(e) => setStat2(e.target.value)}
                      className="w-1/2 px-2 py-1 border rounded"
                    >
                      {statOptions.map((s) => (<option key={s} value={s}>{s}</option>))}
                    </select>
                  </div>
                  <button
                    onClick={runIntersection}
                    disabled={loading || !isValidPlayerName(player1) || !isValidPlayerName(player2)}
                    className="mt-2 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-400"
                  >Run Intersection Query</button>
                </div>
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
