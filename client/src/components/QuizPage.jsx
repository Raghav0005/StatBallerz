import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function QuizPage() {
  const { user } = useAuth();
  if (!user) {
    return <Navigate to="/" replace />;
  }
  return (
    <>
      <div>Quiz Page</div>
    </>
  );
}
