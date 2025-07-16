import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import { searchPlayer } from "../api";

export default function SearchPage() {
  const [query, setQuery] = useState("");
  const [players, setPlayers] = useState([]);
  const { user } = useAuth();

  // Define expected columns for player search results
  const playerColumns = [
    { key: "PLAYERID", header: "Player ID" },
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

  if (!user) {
    return <Navigate to="/" replace />;
  }

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!query) return;

    try {
      const data = await searchPlayer(query);
      if (data.error) {
        alert(`❌ Search failed: ${data.error}`);
        return;
      }

      if (data.results && data.results.length > 0) {
        setPlayers(data.results);
        console.log(data.results);
      } else {
        alert("❌ No player found. Please try again.");
        setPlayers([]);
      }
    } catch (err) {
      console.error("Search error:", err);
      alert("❌ An error occurred while searching. Please try again.");
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <section className="max-w-3xl mx-auto mt-8 px-6">
        <form
          onSubmit={handleSearch}
          className="flex shadow-lg rounded-lg overflow-hidden border border-gray-300 bg-white"
        >
          <input
            type="text"
            placeholder="Search stats, players, teams..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="flex-grow px-5 py-3 text-lg focus:outline-none"
          />
          <button
            type="submit"
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 font-semibold transition"
            onSubmit={handleSearch}
          >
            Search
          </button>
        </form>
      </section>

      <main className="max-w-6xl mx-auto mt-12 px-6 text-gray-600">
        {players.length > 0 ? (
          <div className="mt-6 overflow-auto rounded-lg shadow border border-gray-300">
            <table className="w-full text-sm text-left text-gray-700">
              <thead className="bg-gray-200 text-gray-900 font-semibold">
                <tr>
                  {playerColumns.map((column) => (
                    <th key={column.key} className="p-3">
                      {column.header}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {players.map((player, idx) => (
                  <tr key={idx} className="bg-white border-t">
                    {playerColumns.map((column) => (
                      <td key={column.key} className="p-3">
                        {player[column.key] || "N/A"}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <p>Search for players, stats, or teams above and results will show here.</p>
        )}
      </main>
    </div>
  );
}
