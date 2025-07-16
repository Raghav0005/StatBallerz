import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";
import { getAnsweredAllQuestionsAsUser } from "../api";

export default function SpecialQueriesPage() {
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }

  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleAnsweredAllQuestionsQuery = async () => {
    setLoading(true);
    try {
      const data = await getAnsweredAllQuestionsAsUser(user.username);
      if (data.error) {
        alert(`❌ Query failed: ${data.error}`);
        return;
      }

      if (data.results.length > 0) {
        setUsers(data.results);
      } else {
        alert("❌ No users found who have answered all the same questions as you.");
        setUsers([]);
      }
    } catch (err) {
      console.error("Special query error:", err);
      alert("❌ An error occurred while running the query. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 pt-16 pb-16">
      <section className="max-w-4xl mx-auto mt-8 px-6">
        <h1 className="text-3xl font-bold text-gray-800 mb-8 text-center">Special Queries</h1>
        
        <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
          <h2 className="text-xl font-semibold text-gray-700 mb-4">
            Division Query: Users Who Answered All Your Questions
          </h2>
          <p className="text-gray-600 mb-4">
            This query finds all users who have answered every question that you have answered in quizzes.
          </p>
          <button
            onClick={handleAnsweredAllQuestionsQuery}
            disabled={loading}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
          >
            {loading ? "Running Query..." : "Find Users Who Answered All My Questions"}
          </button>
        </div>
      </section>

      <main className="max-w-4xl mx-auto mt-8 px-6">
        {users.length > 0 ? (
          <div className="bg-white rounded-lg shadow-lg overflow-hidden">
            <div className="bg-gray-200 px-6 py-4">
              <h3 className="text-lg font-semibold text-gray-800">
                Users Who Have Answered All Your Questions ({users.length} found)
              </h3>
            </div>
            <div className="overflow-auto">
              <table className="w-full text-sm text-left text-gray-700">
                <thead className="bg-gray-100 text-gray-900 font-semibold">
                  <tr>
                    <th className="p-4">Username</th>
                  </tr>
                </thead>
                <tbody>
                  {users.map((userResult, idx) => (
                    <tr key={idx} className="bg-white border-t hover:bg-gray-50">
                      <td className="p-4">{userResult.USERNAME || userResult.Username}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        ) : (
          <div className="bg-white rounded-lg shadow-lg p-8 text-center">
            <p className="text-gray-600">
              Click the button above to run the special query and see results here.
            </p>
          </div>
        )}
      </main>
    </div>
  );
}
