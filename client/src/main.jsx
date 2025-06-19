import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './components/login.jsx';
import Signup from './components/signup.jsx';
import './index.css';
import SearchPage from './components/searchpage.jsx';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/home" element={<SearchPage />} /> {/* Optional "main app" page after login */}
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
