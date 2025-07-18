import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import { searchPlayer, searchTeam } from "../api";

export default function SearchPage() {
  const [query, setQuery] = useState("");
  const [searchType, setSearchType] = useState("player");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [expandedTeams, setExpandedTeams] = useState(new Set());
  const { user } = useAuth();

  const formatHeight = (heightInches) => {
    if (!heightInches || heightInches === "-") return "N/A";
    const inches = parseInt(heightInches);
    if (isNaN(inches)) return "N/A";

    const feet = Math.floor(inches / 12);
    const remainingInches = inches % 12;
    return `${feet}'${remainingInches}"`;
  };

  const playerColumns = [
    { key: "PNAME", header: "Name" },
    { key: "BIRTHDATE", header: "Birth Date" },
    { key: "HEIGHT", header: "Height" },
    { key: "BODYWEIGHT", header: "Weight" },
    { key: "DRAFTYEAR", header: "Draft Year" },
    { key: "DRAFTROUND", header: "Round" },
    { key: "DRAFTPICK", header: "Pick" },
    { key: "COUNTRY", header: "Country" },
    { key: "SCHOOL", header: "School" },
  ];

  const teamColumns = [{ key: "TEAMNAME", header: "Team Name" }];

  if (!user) {
    return <Navigate to="/" replace />;
  }

  const handleSearchTypeChange = (e) => {
    setSearchType(e.target.value);
    setResults([]);
    setExpandedTeams(new Set());
  };

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!query || !searchType) return;

    setLoading(true);
    try {
      const data = searchType === "player" ? await searchPlayer(query) : await searchTeam(query);

      if (data.error) {
        alert(`❌ Search failed: ${data.error}`);
        return;
      }

      if (data.results && data.results.length > 0) {
        setResults(data.results);
        console.log(data.results);
      } else {
        alert(`❌ No ${searchType} found. Please try again.`);
        setResults([]);
      }
    } catch (err) {
      console.error("Search error:", err);
      alert("❌ An error occurred while searching. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const toggleTeamExpansion = (teamId) => {
    const newExpanded = new Set(expandedTeams);
    if (newExpanded.has(teamId)) {
      newExpanded.delete(teamId);
    } else {
      newExpanded.add(teamId);
    }
    setExpandedTeams(newExpanded);
  };

  const currentColumns = searchType === "player" ? playerColumns : teamColumns;

  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <section className="max-w-4xl mx-auto mt-8 px-6">
        <form onSubmit={handleSearch} className="space-y-4">
          <div className="flex gap-4">
            <div className="flex-shrink-0">
              <label htmlFor="searchType" className="block text-sm font-medium text-gray-700 mb-1">
                Search Type
              </label>
              <select
                id="searchType"
                value={searchType}
                onChange={handleSearchTypeChange}
                className="px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                required
              >
                <option value="player">Player</option>
                <option value="team">Team</option>
              </select>
            </div>

            <div className="flex-grow">
              <label htmlFor="query" className="block text-sm font-medium text-gray-700 mb-1">
                Search Query
              </label>
              <div className="flex shadow-lg rounded-lg overflow-hidden border border-gray-300 bg-white">
                <input
                  id="query"
                  type="text"
                  placeholder={`Search for ${searchType}s...`}
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  className="flex-grow px-5 py-3 text-lg focus:outline-none"
                  required
                />
                <button
                  type="submit"
                  disabled={loading}
                  className="bg-blue-600 hover:bg-blue-700 text-white px-6 font-semibold transition disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? "Searching..." : "Search"}
                </button>
              </div>
            </div>
          </div>
        </form>
      </section>

      <main className="max-w-6xl mx-auto mt-12 px-6 text-gray-600">
        {results.length > 0 ? (
          <div className="mt-6 space-y-4">
            {searchType === "team" ? (
              results.map((team, idx) => (
                <div key={idx} className="bg-white rounded-lg shadow border border-gray-300">
                  <div className="p-4">
                    <div className="flex items-center justify-between">
                      <div className="flex-grow">
                        <h3 className="text-lg font-semibold text-gray-900">{team.TEAMNAME || "N/A"}</h3>
                      </div>
                      <button
                        onClick={() => toggleTeamExpansion(team.TEAMID)}
                        className="ml-4 px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition"
                      >
                        {expandedTeams.has(team.TEAMID)
                          ? "Hide Players"
                          : `Show Players (${team.players?.length || 0})`}
                      </button>
                    </div>

                    {expandedTeams.has(team.TEAMID) && team.players && team.players.length > 0 && (
                      <div className="mt-4 border-t pt-4">
                        <h4 className="text-md font-medium text-gray-800 mb-2">Team Roster:</h4>
                        <div className="overflow-x-auto">
                          <table className="w-full text-sm">
                            <thead className="bg-gray-50">
                              <tr>
                                <th className="p-2 text-left">Player Name</th>
                                <th className="p-2 text-left">Height</th>
                                <th className="p-2 text-left">Weight (kg)</th>
                              </tr>
                            </thead>
                            <tbody>
                              {team.players.map((player, playerIdx) => (
                                <tr key={playerIdx} className="border-t">
                                  <td className="p-2">{player.PNAME || "N/A"}</td>
                                  <td className="p-2">{formatHeight(player.HEIGHT)}</td>
                                  <td className="p-2">{player.BODYWEIGHT || "N/A"}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              ))
            ) : (
              // Player results in table format
              <div className="overflow-auto rounded-lg shadow border border-gray-300">
                <table className="w-full text-sm text-left text-gray-700">
                  <thead className="bg-gray-200 text-gray-900 font-semibold">
                    <tr>
                      {currentColumns.map((column) => (
                        <th key={column.key} className="p-3">
                          {column.header}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((result, idx) => (
                      <tr key={idx} className="bg-white border-t">
                        {currentColumns.map((column) => (
                          <td key={column.key} className="p-3">
                            {column.key === "HEIGHT" ? formatHeight(result[column.key]) : result[column.key] || "N/A"}
                          </td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        ) : (
          <p>Search for your favourite players or teams!</p>
        )}
      </main>
    </div>
  );
}
