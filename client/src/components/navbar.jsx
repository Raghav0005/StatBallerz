import { useNavigate } from "react-router-dom";

export default function Navbar() {
    const navigate = useNavigate();

    const handleSearch = (e) => {
        e.preventDefault();
        navigate('/home')
    };

    const handleQuiz = (e) => {
        e.preventDefault();
        navigate('/quiz')
    }

    return ( <>
        <nav className="fixed top-0 left-0 right-0 bg-white shadow-md z-20">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
            <div className="text-2xl font-bold text-blue-600">StatBallerZ</div>
            <ul className="flex space-x-8 text-gray-700 font-semibold">
            <li className="hover:text-blue-600 cursor-pointer transition" onClick={handleSearch}>Search</li>
            <li className="hover:text-blue-600 cursor-pointer transition" onClick={handleQuiz}>Quiz</li>
            </ul>
        </div>
        </nav>
        <div className="h-16"></div>
    </>
    )
}
