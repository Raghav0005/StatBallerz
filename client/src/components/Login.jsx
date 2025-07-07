import { useState } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import bgImg from "./../assets/nba.jpg";
import { signinUser } from "../api";
import { useAuth } from "../context/AuthContext";

export default function Login() {
  const { user, login } = useAuth();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  if (user) {
    return <Navigate to="/home" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("Login", { username, password });
    try {
      const result = await signinUser(username, password);
      if (result && !result.error) {
        login({ username });
        navigate("/home");
      } else {
        alert("❌ Login Unsuccessful. Account does not exist with the username/password combination");
      }
    } catch (err) {
      console.error("Login failed:", err);
      alert("❌ Login failed. Please try again later.");
    }
  };

  return (
    <div
      className="relative min-h-screen flex items-center justify-center font-sans bg-cover bg-center bg-no-repeat"
      style={{ backgroundImage: `url(${bgImg})` }}
    >
      <div className="absolute inset-0" style={{ backgroundColor: "rgba(0, 0, 0, 0.6)" }}></div>

      <form onSubmit={handleSubmit} className="relative z-10 bg-white shadow-xl rounded-2xl px-8 py-10 w-full max-w-md">
        <h2 className="text-2xl font-semibold text-gray-800 mb-6 text-center">StatBallerZ 🏀</h2>

        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          className="w-full mb-4 px-4 py-2 border border-gray-300 rounded-xl"
          required
        />
        <input
          type="password"
          placeholder="••••••••"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full mb-6 px-4 py-2 border border-gray-300 rounded-xl"
          required
        />

        <button
          type="submit"
          className="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 rounded-xl transition"
        >
          Log In
        </button>

        <p className="text-center text-sm text-gray-600 mt-4">
          Don’t have an account?{" "}
          <Link to="/signup" className="text-blue-500 hover:underline font-medium">
            Sign up
          </Link>
        </p>
      </form>
    </div>
  );
}
