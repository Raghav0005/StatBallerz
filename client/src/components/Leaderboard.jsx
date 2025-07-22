import React, { useEffect, useState } from "react";

const Leaderboard = () => {
  const [leaderboardData, setLeaderboardData] = useState([]);

  useEffect(() => {
    const fetchLeaderboard = async () => {
      try {
        const res = await fetch("/api/leaderboard");
        const data = await res.json();
        setLeaderboardData(data["results"]);
      } catch (error) {
        setLeaderboardData([]);
      }
    };
    fetchLeaderboard();
  }, []);

  const renderRow = (player, index) => {
    const isTop = index === 0;
    const rowStyle = {
      background: isTop ? "linear-gradient(to right, #d4fc79, #96e6a1)" : "#fff",
      fontWeight: isTop ? "bold" : "normal",
      color: isTop ? "#222" : "#333",
      boxShadow: "0 2px 6px rgba(0,0,0,0.05)",
      borderRadius: 10,
      cursor: "default",
    };

    return (
      <tr key={player.USERNAME} style={rowStyle}>
        <td style={{ padding: "1rem 1.5rem" }}>{player.USERNAME}</td>
        <td style={{ textAlign: "center", padding: "1rem 1.5rem" }}>{player.MAXSCORE}</td>
      </tr>
    );
  };

  return (
    <div
      style={{
        maxWidth: 700,
        margin: "5rem auto 3rem",
        padding: "2.5rem",
        background: "#fdfdfd",
        borderRadius: 16,
        boxShadow: "0 4px 12px rgba(0,0,0,0.08)",
      }}
    >
      <h2
        style={{
          textAlign: "center",
          marginBottom: "2rem",
          fontSize: "2rem",
          color: "#333",
        }}
      >
        🏆 Leaderboard
      </h2>
      <table style={{ width: "100%", borderCollapse: "separate", borderSpacing: "0 1.2rem" }}>
        <thead>
          <tr>
            <th style={{ textAlign: "left", padding: "1rem 1.5rem", fontSize: "1rem", color: "#555" }}>Name</th>
            <th style={{ textAlign: "center", padding: "1rem 1.5rem", fontSize: "1rem", color: "#555" }}>Score</th>
          </tr>
        </thead>
        <tbody>
          {leaderboardData.length > 0 ? (
            leaderboardData.map((player, index) => renderRow(player, index))
          ) : (
            <tr>
              <td colSpan="2" style={{ textAlign: "center", padding: "2rem", color: "#aaa" }}>
                Loading...
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default Leaderboard;
