import { useState } from 'react';
import Navbar from './navbar';

export default function SearchPage() {
  const [query, setQuery] = useState('');

  const handleSearch = (e) => {
    e.preventDefault();
    console.log('Search query:', query);
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <Navbar></Navbar>

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
