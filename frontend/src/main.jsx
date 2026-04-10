import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

// Request persistent storage so iOS/Safari never silently evicts downloaded songs.
// This is a no-op on browsers that don't support it — completely safe to call always.
// Denial is expected in regular browser tabs; only granted when installed as a PWA.
if (navigator.storage?.persist) {
  navigator.storage.persist().then(granted => {
    if (granted) console.log('[Pulse] Persistent storage granted ✓');
    // Denial is expected and non-critical — silently ignored.
  });
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
