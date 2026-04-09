import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './OfflineScreen.css';

export default function OfflineScreen() {
  const navigate = useNavigate();
  const [checking, setChecking] = useState(false);
  const [showToast, setShowToast] = useState(false);

  const handleRetry = async () => {
    setChecking(true);
    setShowToast(false);

    try {
      const res = await fetch('/?_retry=' + Date.now(), {
        method: 'HEAD',
        cache: 'no-store',
        signal: AbortSignal.timeout(5000),
      });

      if (res.ok || res.type === 'opaqueredirect') {
        // We are online — refresh the app entirely
        window.location.reload();
        return;
      }
    } catch { 
      // Still offline
    }

    setChecking(false);
    setShowToast(true);
    setTimeout(() => setShowToast(false), 4000);
  };

  const goToDownloads = () => {
    navigate('/downloads');
  };

  return (
    <div className="offline-screen-container">
      {/* Animated glowing rings */}
      <div className="offline-rings">
        <div className="offline-ring"></div>
        <div className="offline-ring"></div>
        <div className="offline-ring"></div>
        <img src="/pwa-512x512.png" className="offline-logo" alt="Pulse" />
      </div>

      {/* Wifi off icon */}
      <div className="offline-wifi-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <line x1="1" y1="1" x2="23" y2="23" />
          <path d="M16.72 11.06A10.94 10.94 0 0 1 19 12.55" />
          <path d="M5 12.55a10.94 10.94 0 0 1 5.17-2.39" />
          <path d="M10.71 5.05A16 16 0 0 1 22.56 9" />
          <path d="M1.42 9a15.91 15.91 0 0 1 4.7-2.88" />
          <path d="M8.53 16.11a6 6 0 0 1 6.95 0" />
          <circle cx="12" cy="20" r="1" fill="currentColor" stroke="none" />
        </svg>
      </div>

      <h1>You're Offline</h1>
      <p>No internet connection. You can still listen to everything you've downloaded.</p>

      {/* Action buttons */}
      <div className="offline-actions">
        <button 
          className="offline-btn offline-btn-retry" 
          onClick={handleRetry}
          disabled={checking}
        >
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
            <path d="M3 3v5h5" />
          </svg>
          Retry
        </button>

        <button className="offline-btn offline-btn-downloads" onClick={goToDownloads}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
            <polyline points="7 10 12 15 17 10" />
            <line x1="12" y1="15" x2="12" y2="3" />
          </svg>
          Downloads
        </button>
      </div>

      {/* Toast */}
      <div className={`offline-toast ${showToast ? 'show' : ''}`}>
        ⚠️ Still no internet connection. Try again later.
      </div>
    </div>
  );
}
