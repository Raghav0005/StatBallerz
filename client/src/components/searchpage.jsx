import { useState } from 'react';

export default function SearchPage() {
  const [query, setQuery] = useState('');

  const handleSearch = (e) => {
    e.preventDefault();
    console.log('Search query:', query);
  };

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Navbar */}
      <nav className="fixed top-0 left-0 right-0 bg-white shadow-md z-20">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="text-2xl font-bold text-blue-600">StatBallerZ</div>
          <ul className="flex space-x-8 text-gray-700 font-semibold">
            <li className="hover:text-blue-600 cursor-pointer transition">Search</li>
            <li className="hover:text-blue-600 cursor-pointer transition">Quiz</li>
          </ul>
        </div>
      </nav>
      <div className="h-16"></div>

      {/* Search bar */}
      <section className="max-w-3xl mx-auto mt-8 px-6">
        <form onSubmit={handleSearch} className="flex shadow-lg rounded-lg overflow-hidden border border-gray-300 bg-white">
          <input
            type="text"
            placeholder="Search stats, players, teams..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="flex-grow px-5 py-3 text-lg focus:outline-none"
          />
          <button
            type="submit"
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 font-semibold transition"
          >
            Search
          </button>
        </form>
      </section>

      {/* Content placeholder */}
      <main className="max-w-3xl mx-auto mt-12 px-6 text-gray-600">
        <p>Search for players, stats, or teams above and results will show here.</p>
      </main>
    </div>
  );
}
