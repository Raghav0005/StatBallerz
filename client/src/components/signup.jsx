import { useState } from 'react';
import { Link } from 'react-router-dom';
import bgImg from './../assets/nba.jpg';
import { signup } from '../api';

export default function Signup() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (password !== confirm) {
      alert('Passwords do not match!');
      return;
    }

    console.log('Signup', { username, password });

    try {
      const result = await signup(username, password);
      console.log('Signup Success!', result);
      alert('✅ Signup successful! You can now log in.');

    } catch (err) {
      console.error('Signup failed:', err);
    }
  };

  return (
    <div
      className="relative min-h-screen flex items-center justify-center font-sans bg-cover bg-center bg-no-repeat"
      style={{ backgroundImage: `url(${bgImg})` }}
    >
      {/* Overlay to dim background */}
      <div
        className="absolute inset-0"
        style={{ backgroundColor: 'rgba(0, 0, 0, 0.6)' }}
      ></div>

      {/* Form content above overlay */}
      <form
        onSubmit={handleSubmit}
        className="relative z-10 bg-white shadow-xl rounded-2xl px-8 py-10 w-full max-w-md"
      >
        <h2 className="text-2xl font-semibold text-gray-800 mb-6 text-center">
          Join StatBallerZ 🏀
        </h2>

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
          Already have an account?{' '}
          <Link to="/" className="text-blue-500 hover:underline font-medium">
            Log in
          </Link>
        </p>
      </form>
    </div>
  );
}
