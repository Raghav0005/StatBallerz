import { useState } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { fetchGameStats } from "../api";

export default function GamesPage() {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [stat, setStat] = useState("Points");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!startDate || !endDate || !stat) return;

    setLoading(true);
    try {
      console.log("Query parameters:", { startDate, endDate, stat });
      const response = await fetchGameStats(startDate, endDate, stat);
      console.log("Full response:", response);
      if (response.error) {
        alert(`❌ Error fetching game stats: ${response.error}`);
        return;
      }
      const results = response.data.results || [];
      console.log("Parsed results:", results);
      setResults(results);
    } catch (error) {
      console.error("Error fetching game stats:", error);
      alert("Failed to fetch game stats. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <div className="h-16" />
      <div className="p-6">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl font-bold text-gray-800 mb-8">Game Statistics</h1>

          <div className="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 className="text-xl font-semibold mb-4">Search Game Stats by Date Range</h2>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label htmlFor="startDate" className="block text-sm font-medium text-gray-700 mb-1">
                    Start Date
                  </label>
                  <input
                    type="date"
                    id="startDate"
                    value={startDate}
                    onChange={(e) => setStartDate(e.target.value)}
                    min="2024-01-01"
                    max="2025-12-31"
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    required
                  />
                </div>

                <div>
                  <label htmlFor="endDate" className="block text-sm font-medium text-gray-700 mb-1">
                    End Date
                  </label>
                  <input
                    type="date"
                    id="endDate"
                    value={endDate}
                    onChange={(e) => setEndDate(e.target.value)}
                    min={startDate || "2024-01-01"}
                    max="2025-12-31"
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    required
                  />
                </div>

                <div>
                  <label htmlFor="stat" className="block text-sm font-medium text-gray-700 mb-1">
                    Statistic
                  </label>
                  <select
                    id="stat"
                    value={stat}
                    onChange={(e) => setStat(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    required
                  >
                    <option value="Points">Points</option>
                    <option value="Assists">Assists</option>
                    <option value="TotalRebounds">Total Rebounds</option>
                    <option value="Steals">Steals</option>
                    <option value="Blocks">Blocks</option>
                    <option value="Turnovers">Turnovers</option>
                    <option value="FieldGoalMade">Field Goals Made</option>
                    <option value="FieldGoalAttempt">Field Goals Attempted</option>
                    <option value="ThreePointMade">Three Pointers Made</option>
                    <option value="ThreePointAttempt">Three Pointers Attempted</option>
                    <option value="FreeThrowMade">Free Throws Made</option>
                    <option value="FreeThrowAttempt">Free Throws Attempted</option>
                    <option value="PersonalFouls">Personal Fouls</option>
                    <option value="NumSeconds">Minutes Played (Seconds)</option>
                  </select>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full md:w-auto px-6 py-2 bg-blue-600 text-white font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? "Searching..." : "Search Games"}
              </button>
            </form>
          </div>

          {results.length > 0 && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-lg font-semibold mb-4">Results ({results.length} games found)</h3>
              <div className="overflow-x-auto">
                <table className="min-w-full table-auto">
                  <thead>
                    <tr className="bg-gray-50">
                      <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">Game ID</th>
                      <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">Average Statistic</th>
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((result, index) => (
                      <tr key={index} className="border-t">
                        <td className="px-4 py-2 text-sm text-gray-900">{result.GAMEID}</td>
                        <td className="px-4 py-2 text-sm text-gray-900">
                          {parseFloat(result.AVG_STAT || 0).toFixed(2)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* No Results Message */}
          {!loading && results.length === 0 && (
            <div className="bg-white rounded-lg shadow-md p-6 text-center">
              <p className="text-gray-500">
                No games found for the selected date range. Try adjusting your search criteria.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
