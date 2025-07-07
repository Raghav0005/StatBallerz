import { useNavigate } from "react-router-dom";

export default function Navbar() {
  const navigate = useNavigate();

  return (
    <>
      <nav className="fixed top-0 left-0 right-0 bg-white shadow-md z-20">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="text-2xl font-bold text-blue-600">StatBallerZ</div>
          <ul className="flex space-x-8 text-gray-700 font-semibold">
            <li className="hover:text-blue-600 cursor-pointer transition" onClick={() => navigate("/home")}>
              Search
            </li>
            <li className="hover:text-blue-600 cursor-pointer transition" onClick={() => navigate("/quiz")}>
              Quiz
            </li>
            <li className="hover:text-blue-600 cursor-pointer transition" onClick={() => navigate("/profile")}>
              Profile
            </li>
          </ul>
        </div>
      </nav>
      <div className="h-16"></div>
    </>
  );
}
