import { Routes, Route } from "react-router-dom";
import Login from "./components/Login";
import Signup from "./components/Signup";
import SearchPage from "./components/SearchPage";
import QuizPage from "./components/QuizPage";
import ProfilePage from "./components/ProfilePage";
import SpecialQueriesPage from "./components/SearchQueriesPage";
import Layout from "./components/Layout";
import GamesPage from "./components/GamesPage";
import Leaderboard from "./components/Leaderboard";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/signup" element={<Signup />} />

      <Route element={<Layout />}>
        <Route path="/home" element={<SearchPage />} />
        <Route path="/games" element={<GamesPage />} />
        <Route path="/quiz" element={<QuizPage />} />
        <Route path="/special-queries" element={<SpecialQueriesPage />} />
        <Route path="/profile" element={<ProfilePage />} />
        <Route path="/leaderboard" element={<Leaderboard />} />
      </Route>
    </Routes>
  );
}
