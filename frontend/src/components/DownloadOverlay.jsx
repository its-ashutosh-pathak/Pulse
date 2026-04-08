import React, { useEffect, useState } from 'react';
import { subscribeToDownload } from '../utils/downloadManager';
import './DownloadOverlay.css';

export default function DownloadOverlay({ videoId }) {
  const [progress, setProgress] = useState(0);
  const [status, setStatus] = useState('idle');

  useEffect(() => {
    if (!videoId) return;
    return subscribeToDownload(videoId, (p, s) => {
      setProgress(p);
      setStatus(s);
    });
  }, [videoId]);

  if (status !== 'downloading') return null;

  return (
    <div className="dl-overlay-container">
      <div 
        className="dl-overlay-fill" 
        style={{ height: `${progress * 100}%` }} 
      />
    </div>
  );
}
