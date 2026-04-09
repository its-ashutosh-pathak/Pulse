import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

// Request persistent storage so iOS/Safari never silently evicts downloaded songs.
// This is a no-op on browsers that don't support it — completely safe to call always.
if (navigator.storage?.persist) {
  navigator.storage.persist().then(granted => {
    if (granted) console.log('[Pulse] Persistent storage granted — downloads are safe from eviction.');
    else console.warn('[Pulse] Persistent storage denied — downloads may be evicted on low-storage iOS devices.');
  });
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
