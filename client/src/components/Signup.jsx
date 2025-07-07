import { useState } from "react";
import { Link, Navigate } from "react-router-dom";
import bgImg from "./../assets/nba.jpg";
import { signinUser, signupUser } from "../api";
import { AuthContext } from "../context/AuthContext";
import { useContext } from "react";
import { useNavigate } from "react-router-dom";

export default function Signup() {
  const { user, login } = useContext(AuthContext);
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");

  if (user) {
    return <Navigate to="/home" replace />;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (password !== confirm) {
      alert("Passwords do not match!");
      return;
    }

    try {
      const signupRes = await signupUser(username, password);
      // auto login
      if (!signupRes.error) {
        const signInRes = await signinUser(username, password);
        if (!signInRes.error) {
          login({ username });
          navigate("/home");
        } else {
          alert("✅ Signup succeeded, but auto-login failed. Please log in manually.");
        }
      } else {
        alert("❌ Signup failed. Try again with a different username.");
      }
    } catch (err) {
      console.error("Signup failed:", err);
      alert("❌ An error occurred during signup. Please try again.");
    }
  };

  return (
    <div
      className="relative min-h-screen flex items-center justify-center font-sans bg-cover bg-center bg-no-repeat"
      style={{ backgroundImage: `url(${bgImg})` }}
    >
      <div className="absolute inset-0" style={{ backgroundColor: "rgba(0, 0, 0, 0.6)" }}></div>

      <form onSubmit={handleSubmit} className="relative z-10 bg-white shadow-xl rounded-2xl px-8 py-10 w-full max-w-md">
        <h2 className="text-2xl font-semibold text-gray-800 mb-6 text-center">Join StatBallerZ 🏀</h2>

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
          placeholder="Create a password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full mb-4 px-4 py-2 border border-gray-300 rounded-xl"
          required
        />
        <input
          type="password"
          placeholder="Confirm password"
          value={confirm}
          onChange={(e) => setConfirm(e.target.value)}
          className="w-full mb-6 px-4 py-2 border border-gray-300 rounded-xl"
          required
        />

        <button
          type="submit"
          className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 rounded-xl transition"
        >
          Sign Up
        </button>

        <p className="text-center text-sm text-gray-600 mt-4">
          Already have an account?{" "}
          <Link to="/" className="text-blue-500 hover:underline font-medium">
            Log in
          </Link>
        </p>
      </form>
    </div>
  );
}
