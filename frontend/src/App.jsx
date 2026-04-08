import React, { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { PlaylistProvider } from './context/PlaylistContext';
import { AudioProvider } from './context/AudioContext';

// Components & Pages
import Layout from './components/Layout';
import Home from './pages/Home';
import Library from './pages/Library';
import PlayerView from './pages/PlayerView';
import Login from './pages/Login';
import PlaylistView from './pages/PlaylistView';
import Search from './pages/Search';
import Settings from './pages/Settings';
import Profile from './pages/Profile';
import ArtistView from './pages/ArtistView';
import Downloads from './pages/Downloads';

// Wraps any route — redirects to /login if not authenticated
function ProtectedRoute({ children }) {
  const { user } = useAuth();
  return user ? children : <Navigate to="/login" replace />;
}

function AppRoutes() {
  const { pathname } = useLocation();

  // Scroll to top on route change
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);

  // Global Theme Initialization
  useEffect(() => {
    const savedColor = localStorage.getItem('pulse_accent_color') || '#865AA4';
    
    // Function to shift hue for secondary color
    const getSecondaryColor = (hex) => {
      // Hex to RGB
      let r = parseInt(hex.slice(1, 3), 16) / 255;
      let g = parseInt(hex.slice(3, 5), 16) / 255;
      let b = parseInt(hex.slice(5, 7), 16) / 255;

      // RGB to HSL
      let max = Math.max(r, g, b), min = Math.min(r, g, b);
      let h, s, l = (max + min) / 2;
      if (max === min) h = s = 0;
      else {
        let d = max - min;
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        switch (max) {
          case r: h = (g - b) / d + (g < b ? 6 : 0); break;
          case g: h = (b - r) / d + 2; break;
          case b: h = (r - g) / d + 4; break;
          default: h = 0; break;
        }
        h /= 6;
      }

      // Shift Hue (approx 40 degrees) and adjust saturation
      h = (h + 0.11) % 1; 
      s = Math.min(1, s * 1.1);
      l = Math.max(0.1, Math.min(0.9, l * 0.9));

      // HSL to RGB
      const hue2rgb = (p, q, t) => {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
      }
      let q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      let p = 2 * l - q;
      r = hue2rgb(p, q, h + 1/3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1/3);

      // RGB back to HEX
      const toHex = x => {
        const hexVal = Math.round(x * 255).toString(16);
        return hexVal.length === 1 ? '0' + hexVal : hexVal;
      };
      return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
    };

    const secondary = getSecondaryColor(savedColor);
    document.documentElement.style.setProperty('--accent-cyan', savedColor);
    document.documentElement.style.setProperty('--accent-pink', secondary);
  }, []);

  return (
    <Routes>
      {/* Public */}
      <Route path="/login" element={<Login />} />

      {/* Protected — with bottom nav */}
      <Route path="/" element={<ProtectedRoute><Layout /></ProtectedRoute>}>
        <Route index element={<Home />} />
        <Route path="library" element={<Library />} />
        <Route path="search" element={<Search />} />
        <Route path="settings"     element={<Settings />} />
        <Route path="profile"      element={<Profile />} />
        <Route path="downloads"    element={<Downloads />} />
        <Route path="playlist/:id" element={<PlaylistView />} />
        <Route path="artist/:id"   element={<ArtistView />} />
      </Route>

      {/* Protected — fullscreen (no bottom nav) */}
      <Route path="/player" element={<ProtectedRoute><PlayerView /></ProtectedRoute>} />
    </Routes>
  );
}

// ... (existing code)

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AudioProvider>
          <PlaylistProvider>
            <AppRoutes />
          </PlaylistProvider>
        </AudioProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
