import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import { searchPlayer } from "../api";

export default function SearchPage() {
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }

  const [query, setQuery] = useState("");
  const [players, setPlayers] = useState([]);


  const handleSearch = async (e) => {
    e.preventDefault();
    if (!query) return;

    try {
      const data = await searchPlayer(query);
      if (data.error) {
        alert(`❌ Search failed: ${data.error}`);
        return;
      }

      const rows = data.results || [];
      const parsedPlayers = [];

      for (const entry of rows) {
        const rawKey = Object.keys(entry)[0];
        const rawValue = entry[rawKey];

        const headers = rawKey.trim().split(/\s+/);
        const values = rawValue.trim().split(/\s+/);

        // Safely handle multi-word name
        const parsed = {};
        parsed[headers[0]] = values[0]; // PLAYERID
        parsed[headers[1]] = values[1] + " " + values[2]; // PNAME
        parsed[headers[2]] = values[3]; // BIRTHDATE
        parsed[headers[3]] = values[4]; // HEIGHT
        parsed[headers[4]] = values[5]; // BODYWEIGHT
        parsed[headers[5]] = values[6]; // DRAFTYEAR
        parsed[headers[6]] = values[7]; // DRAFTROUND
        parsed[headers[7]] = values[8]; // DRAFTPICK
        parsed[headers[8]] = values[9]; // COUNTRY
        parsed[headers[9]] = values[10]; // SCHOOL

        parsedPlayers.push(parsed);
      }

      setPlayers(parsedPlayers);
    } catch (err) {
      console.error("Search error:", err);
      alert("❌ An error occurred while searching. Please try again.");
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <div className="h-16"></div>
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

      <main className="max-w-3xl mx-auto mt-12 px-6 text-gray-600">
        {players.length > 0 ? (
        <div className="mt-6 overflow-auto rounded-lg shadow border border-gray-300">
          <table className="w-full text-sm text-left text-gray-700">
            <thead className="bg-gray-200 text-gray-900 font-semibold">
              <tr>
                <th className="p-3">Player ID</th>
                <th className="p-3">Name</th>
                <th className="p-3">Birthdate</th>
                <th className="p-3">Height</th>
                <th className="p-3">Weight</th>
                <th className="p-3">Draft Year</th>
                <th className="p-3">Round</th>
                <th className="p-3">Pick</th>
                <th className="p-3">Country</th>
                <th className="p-3">School</th>
              </tr>
            </thead>
            <tbody>
              {players.map((player, idx) => (
                <tr key={idx} className="bg-white border-t">
                  <td className="p-3">{player.PLAYERID}</td>
                  <td className="p-3">{player.PNAME}</td>
                  <td className="p-3">{player.BIRTHDATE}</td>
                  <td className="p-3">{player.HEIGHT}</td>
                  <td className="p-3">{player.BODYWEIGHT}</td>
                  <td className="p-3">{player.DRAFTYEAR}</td>
                  <td className="p-3">{player.DRAFTROUND}</td>
                  <td className="p-3">{player.DRAFTPICK}</td>
                  <td className="p-3">{player.COUNTRY}</td>
                  <td className="p-3">{player.SCHOOL}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div> ) :
        <p>
          Search for players, stats, or teams above and results will show here.
        </p>}
      </main>
    </div>
  );
}
