import { Navigate, useNavigate } from "react-router-dom";
import { deleteUser, updatePassword} from "../api";
import { useAuth } from "../context/AuthContext";
import { useState } from "react";

export default function ProfilePage() {
  const { user, logout } = useAuth();
  const [ newPassword, setNewPassword ] = useState();
  const navigate = useNavigate();

  if (!user) {
    return <Navigate to="/" replace />;
  }

  async function handleChangePassword(e) {
    e.preventDefault()
    try {
      const data = await updatePassword(user.username, newPassword);
      if (data.error) {
        alert(`❌ Password update was unsuccessful. ${data.error}`);
        return;
      }
      alert("Password updated successfully!");
      setNewPassword("");
    } catch (error) {
      alert("Failed to delete account: " + error.message);
    }
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
      <div className="h-16"></div>
      <h1 className="text-2xl font-bold mb-4">Profile Page</h1>
      <p>
        Logged in as: <strong>{user.username}</strong>
      </p>
      <form className="mt-6 space-y-4">
        <div>
          <label className="block mb-1 font-medium">New Password</label>
          <input
            type="password"
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            className="w-full px-3 py-2 border rounded"
            required
          />
        </div>
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition disabled:opacity-50"
          onClick={handleChangePassword}
        >
        Change Password
        </button>
      </form>
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
