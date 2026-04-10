import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { Eye, EyeOff } from 'lucide-react';
import './Login.css';

export default function Login() {
  const { user, loading, loginWithEmail, signupWithEmail } = useAuth();
  const navigate = useNavigate();
  const [isSignup, setIsSignup] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);

  // Redirect as soon as auth state confirms the user is logged in.
  // This handles both: initial load (already logged in) and post-submit.
  useEffect(() => {
    if (!loading && user) {
      navigate('/', { replace: true });
    }
  }, [user, loading, navigate]);

  const handleEmailAuth = async (e) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);
    try {
      if (isSignup) {
        await signupWithEmail(email, password, name);
      } else {
        await loginWithEmail(email, password);
      }
      // Navigation handled by the useEffect above when user state updates
    } catch (e) {
      setError(e.message.replace('Firebase: ', '').replace(/\(auth\/.*\)/, '').trim());
    } finally {
      setSubmitting(false);
    }
  };

  // Don't render the form while auth is resolving to avoid flash
  if (loading) return null;

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
          <div className="password-wrapper">
            <input
              type={showPassword ? 'text' : 'password'}
              placeholder="Password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
              className="input-field password-input"
            />
            <button
              type="button"
              className="password-eye"
              onClick={() => setShowPassword(v => !v)}
              tabIndex={-1}
              aria-label={showPassword ? 'Hide password' : 'Show password'}
            >
              {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>
          {error && <p className="error-msg">{error}</p>}
          <button type="submit" className="submit-btn hover-scale" disabled={submitting}>
            {submitting ? 'Please wait...' : isSignup ? 'Create Account' : 'Sign In'}
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
