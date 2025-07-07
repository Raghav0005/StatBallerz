import { Navigate, useNavigate } from "react-router-dom";
import { deleteUser } from "../api";
import { useAuth } from "../context/AuthContext";

export default function ProfilePage() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  if (!user) {
    return <Navigate to="/" replace />;
  }

  async function handleDelete() {
    if (!window.confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
      return;
    }

    try {
      await deleteUser(user.username);
      alert("Account deleted successfully.");
      logout();
      navigate("/");
    } catch (error) {
      alert("Failed to delete account: " + error.message);
    }
  }

  function handleLogout() {
    logout();
    navigate("/");
  }

  return (
    <div className="p-6 max-w-md mx-auto">
      <h1 className="text-2xl font-bold mb-4">Profile Page</h1>
      <p>
        Logged in as: <strong>{user.username}</strong>
      </p>
      <div className="mt-6 space-x-4">
        <button onClick={handleDelete} className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition">
          Delete Account
        </button>
        <button
          onClick={handleLogout}
          className="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition"
        >
          Logout
        </button>
      </div>
    </div>
  );
}
