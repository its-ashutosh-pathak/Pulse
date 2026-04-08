import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import './Login.css';

export default function Login() {
  const { loginWithEmail, signupWithEmail } = useAuth();
  const navigate = useNavigate();
  const [isSignup, setIsSignup] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleEmailAuth = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      if (isSignup) {
        await signupWithEmail(email, password, name);
      } else {
        await loginWithEmail(email, password);
      }
      navigate('/');
    } catch (e) {
      setError(e.message.replace('Firebase: ', '').replace(/\(auth\/.*\)/, '').trim());
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-card glass">
        <img src="/logo.png" alt="Pulse" className="login-logo" />
        <h1>Pulse</h1>
        <p className="login-sub">Feel Every Beat!</p>
        <p className="login-footer">
          Made with ❤️ by <a href="https://itsashutoshpathak.vercel.app/" target="_blank" rel="noopener noreferrer">Ashutosh Pathak</a>
        </p>

        <form className="login-form" onSubmit={handleEmailAuth}>
          {isSignup && (
            <input
              type="text"
              placeholder="Your name"
              value={name}
              onChange={e => setName(e.target.value)}
              required
              className="input-field"
            />
          )}
          <input
            type="email"
            placeholder="Email address"
            value={email}
            onChange={e => setEmail(e.target.value)}
            required
            className="input-field"
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            required
            className="input-field"
          />
          {error && <p className="error-msg">{error}</p>}
          <button type="submit" className="submit-btn hover-scale" disabled={loading}>
            {loading ? 'Please wait...' : isSignup ? 'Create Account' : 'Sign In'}
          </button>
        </form>

        <p className="toggle-auth">
          {isSignup ? 'Already have an Pulse account? ' : "Don't have an Pulse account? "}
          <button onClick={() => { setIsSignup(!isSignup); setError(''); }}>
            {isSignup ? 'Sign In' : 'Sign Up'}
          </button>
        </p>
      </div>
    </div>
  );
}
