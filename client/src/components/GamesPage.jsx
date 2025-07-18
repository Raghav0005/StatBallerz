import { useState } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { fetchGameStats, fetchGameDetails } from "../api";

export default function GamesPage() {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [stat, setStat] = useState("Points");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [displayedStat, setDisplayedStat] = useState("");
  const { user } = useAuth();

  const statDisplayNames = {
    Points: "Points",
    Assists: "Assists",
    TotalRebounds: "Total Rebounds",
    Steals: "Steals",
    Blocks: "Blocks",
    Turnovers: "Turnovers",
    FieldGoalMade: "Field Goals Made",
    FieldGoalAttempt: "Field Goals Attempted",
    ThreePointMade: "Three Pointers Made",
    ThreePointAttempt: "Three Pointers Attempted",
    FreeThrowMade: "Free Throws Made",
    FreeThrowAttempt: "Free Throws Attempted",
    PersonalFouls: "Personal Fouls",
  };

  if (!user) {
    return <Navigate to="/" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!startDate || !endDate || !stat) return;

    setLoading(true);
    try {
      const statsResponse = await fetchGameStats(startDate, endDate, stat);

      if (statsResponse.error) {
        alert(`❌ Error fetching game stats: ${statsResponse.error}`);
        return;
      }

      const gameStats = statsResponse.data.results || [];

      if (gameStats.length === 0) {
        setResults([]);
        setDisplayedStat("");
        return;
      }

      const gameIds = gameStats.map((game) => game.GAMEID).join(",");
      const detailsResponse = await fetchGameDetails(gameIds);

      if (detailsResponse.error) {
        console.warn("Failed to fetch game details, showing game IDs instead");
        setResults(gameStats);
        setDisplayedStat(stat);
        return;
      }

      const gameDetails = detailsResponse.data.results || [];

      const mergedResults = gameStats.map((statResult) => {
        const details = gameDetails.find((detail) => detail.GAMEID === statResult.GAMEID);
        return {
          ...statResult,
          GAMEDATE: details?.GAMEDATE || null,
          HOME_TEAM: details?.HOME_TEAM || null,
          AWAY_TEAM: details?.AWAY_TEAM || null,
        };
      });

      setResults(mergedResults);
      setDisplayedStat(stat);
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
        <div className="max-w-6xl mx-auto">
          <h1 className="text-3xl font-bold text-gray-800 mb-8">Game Statistics Analysis</h1>

          <div className="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 className="text-xl font-semibold mb-2">Player Performance by Game</h2>
            <p className="text-gray-600 mb-4">
              Find games within a date range and see the average player performance for each statistic. Results show the
              average {statDisplayNames[stat]?.toLowerCase() || stat.toLowerCase()} per player in each game.
            </p>

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
                  </select>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full md:w-auto px-6 py-2 bg-blue-600 text-white font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? "Analyzing..." : "Analyze Games"}
              </button>
            </form>
          </div>

          {results.length > 0 && displayedStat && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-lg font-semibold mb-2">Game Analysis Results ({results.length} games found)</h3>
              <p className="text-sm text-gray-600 mb-4">
                Average {statDisplayNames[displayedStat]} per player in each game, ordered by most recent games
              </p>
              <div className="overflow-x-auto">
                <table className="min-w-full table-auto">
                  <thead>
                    <tr className="bg-gray-50">
                      <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">Game Date</th>
                      <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">Matchup</th>
                      <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">
                        Average {statDisplayNames[displayedStat]}
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((result, index) => (
                      <tr key={index} className="border-t">
                        <td className="px-4 py-2 text-sm text-gray-900">
                          {result.GAMEDATE ? new Date(result.GAMEDATE).toLocaleDateString() : "N/A"}
                        </td>
                        <td className="px-4 py-2 text-sm text-gray-900">
                          {result.HOME_TEAM && result.AWAY_TEAM ? (
                            <>
                              <span className="font-medium">{result.AWAY_TEAM}</span>
                              <span className="text-gray-500 mx-2">@</span>
                              <span className="font-medium">{result.HOME_TEAM}</span>
                            </>
                          ) : (
                            <span className="text-gray-600">Game ID: {result.GAMEID}</span>
                          )}
                        </td>
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

          {!loading && results.length === 0 && (
            <div className="bg-white rounded-lg shadow-md p-6 text-center">
              <p className="text-gray-500">
                No games found for the selected date range and statistic. Try adjusting your search criteria.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
