import React, { useState, useEffect, useRef } from 'react';
import { Volume2, Smartphone, Shield, Info, ExternalLink, Moon, Music, Palette } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import './Settings.css';




// Map between UI labels and backend storage values
const toBackendQuality = (q) => ({ automatic: 'auto', normal: 'medium' }[q] ?? q);
const toFrontendQuality = (q) => ({ auto: 'automatic', medium: 'normal' }[q] ?? q);

export default function Settings() {
  const { user } = useAuth();
  const [streamingQuality, setStreamingQuality] = useState(() => toFrontendQuality(localStorage.getItem('pulse_streaming_quality') || 'automatic'));

  const [downloadQuality, setDownloadQuality] = useState(() => toFrontendQuality(localStorage.getItem('pulse_download_quality') || 'high'));
  const [crossfade, setCrossfade] = useState(() => parseInt(localStorage.getItem('pulse_crossfade') || '0'));
  const [accentColor, setAccentColor] = useState(() => localStorage.getItem('pulse_accent_color') || '#865AA4');
  const [dataSaver, setDataSaver] = useState(() => localStorage.getItem('pulse_data_saver') === 'true');
  const [isPickerOpen, setIsPickerOpen] = useState(false);
  const pickerRef = useRef(null);

  // HSV State for integrated picker
  const [hsv, setHsv] = useState({ h: 280, s: 50, v: 50 });

  // Helper to generate secondary color (same logic as App.jsx)
  const getSecondaryColor = (hex) => {
    let r = parseInt(hex.slice(1, 3), 16) / 255;
    let g = parseInt(hex.slice(3, 5), 16) / 255;
    let b = parseInt(hex.slice(5, 7), 16) / 255;
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
    h = (h + 0.11) % 1; 
    s = Math.min(1, s * 1.1);
    l = Math.max(0.1, Math.min(0.9, l * 0.9));
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
    r = hue2rgb(p, q, h + 1/3); g = hue2rgb(p, q, h); b = hue2rgb(p, q, h - 1/3);
    const toHex = x => {
      const hexVal = Math.round(x * 255).toString(16);
      return hexVal.length === 1 ? '0' + hexVal : hexVal;
    };
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
  };

  const hsvToHex = (h, s, v) => {
    s /= 100; v /= 100;
    let i = Math.floor(h / 60);
    let f = h / 60 - i;
    let p = v * (1 - s);
    let q = v * (1 - f * s);
    let t = v * (1 - (1 - f) * s);
    let r, g, b;
    switch (i % 6) {
      case 0: r = v; g = t; b = p; break;
      case 1: r = q; g = v; b = p; break;
      case 2: r = p; g = v; b = t; break;
      case 3: r = p; g = q; b = v; break;
      case 4: r = t; g = p; b = v; break;
      case 5: r = v; g = p; b = q; break;
    }
    const toHex = x => {
      const hex = Math.round(x * 255).toString(16);
      return hex.length === 1 ? '0' + hex : hex;
    };
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
  };

  const updateColorFromHsv = (h, s, v) => {
    const hex = hsvToHex(h, s, v).toUpperCase();
    setAccentColor(hex);
    setHsv({ h, s, v });
  };

  const handleReset = () => {
    const defaultColor = '#865AA4';
    setAccentColor(defaultColor);
    setHsv({ h: 280, s: 45, v: 64 }); // Approx for #865AA4
  };

  const handleHexInput = (e) => {
    let val = e.target.value.toUpperCase().replace('#', '');
    if (/^[0-9A-F]{0,6}$/.test(val)) {
      const fullHex = `#${val}`;
      setAccentColor(fullHex);
      
      // If it's a full 6-char hex, update the HSV for the picker grid too
      if (val.length === 6) {
        let r = parseInt(val.slice(0, 2), 16) / 255;
        let g = parseInt(val.slice(2, 4), 16) / 255;
        let b = parseInt(val.slice(4, 6), 16) / 255;
        let max = Math.max(r, g, b), min = Math.min(r, g, b);
        let h, s, v = max;
        let d = max - min;
        s = max === 0 ? 0 : d / max;
        if (max === min) h = 0;
        else {
          switch (max) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            case b: h = (r - g) / d + 4; break;
          }
          h /= 6;
        }
        setHsv({ h: h * 360, s: s * 100, v: v * 100 });
      }
    }
  };

  // Live preview + persist accent color
  useEffect(() => {
    if (!accentColor || accentColor.length < 4) return;
    const secondary = getSecondaryColor(accentColor);
    document.documentElement.style.setProperty('--accent-cyan', accentColor);
    document.documentElement.style.setProperty('--accent-pink', secondary);

    const timer = setTimeout(() => {
      localStorage.setItem('pulse_accent_color', accentColor);
    }, 600);
    return () => clearTimeout(timer);
  }, [accentColor, user]);

  // Persist playback settings to localStorage + backend
  useEffect(() => {
    localStorage.setItem('pulse_streaming_quality', streamingQuality);
    localStorage.setItem('pulse_download_quality', downloadQuality);
    localStorage.setItem('pulse_crossfade', String(crossfade));
    localStorage.setItem('pulse_data_saver', String(dataSaver));

  }, [streamingQuality, downloadQuality, crossfade, dataSaver, user]);


  // Click Outside to Close
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (pickerRef.current && !pickerRef.current.contains(event.target)) {
        setIsPickerOpen(false);
      }
    };
    if (isPickerOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      document.addEventListener('touchstart', handleClickOutside);
    }
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('touchstart', handleClickOutside);
    };
  }, [isPickerOpen]);

  return (
    <div className="settings-container">
      <header className="settings-header">
        <h1>Settings</h1>
      </header>

      <section className="settings-section">
        <div className="section-title">
          <Volume2 size={16} />
          <span>Streaming Quality</span>
        </div>
        <div className="settings-options glass">
          {['automatic', 'low', 'normal', 'high'].map(q => (
            <button
              key={q}
              className={`quality-selection-item ${streamingQuality === q ? 'active' : ''}`}
              onClick={() => setStreamingQuality(q)}
            >
              <span className="capitalize">{q}</span>
              <div className="radio-circle">
                <div className="radio-dot" />
              </div>
            </button>
          ))}
        </div>
      </section>

      <section className="settings-section">
        <div className="section-title">
          <Volume2 size={16} />
          <span>Download Quality</span>
        </div>
        <div className="settings-options glass">
          {['automatic', 'low', 'normal', 'high'].map(q => (
            <button
              key={q}
              className={`quality-selection-item ${downloadQuality === q ? 'active' : ''}`}
              onClick={() => setDownloadQuality(q)}
            >
              <span className="capitalize">{q}</span>
              <div className="radio-circle">
                <div className="radio-dot" />
              </div>
            </button>
          ))}
        </div>
      </section>

      <section className="settings-section">
        <div className="section-title">
          <Music size={16} />
          <span>Playback</span>
        </div>
        <div className="settings-options glass">
          <div className="playback-setting">
            <div className="playback-info">
              <span>Crossfade</span>
              <p>Overlap tracks for gapless transitions</p>
            </div>
            <div className="crossfade-control">
              <span className="fade-val">{crossfade}s</span>
              <input
                type="range"
                min="0" max="12"
                value={crossfade}
                onChange={(e) => setCrossfade(parseInt(e.target.value))}
                className="pulse-slider"
              />
            </div>
          </div>
        </div>
      </section>

      <section className="settings-section">
        <div className="section-title">
          <Smartphone size={16} />
          <span>Data Usage</span>
        </div>
        <div className="settings-options glass">
          <div className="settings-toggle">
            <div className="toggle-info">
              <span>Data Saver</span>
              <p>Stream at lower quality over cellular</p>
            </div>
            <label className="switch">
              <input type="checkbox" checked={dataSaver} onChange={() => setDataSaver(!dataSaver)} />
              <span className="slider round"></span>
            </label>
          </div>
        </div>
      </section>



      <section className="settings-section">
        <div className="section-title">
          <Shield size={16} />
          <span>Appearance</span>
        </div>
        <div className="settings-options glass" ref={pickerRef}>
          <div className="accent-picker-row">
            <div className="accent-picker-content">
              <div className="accent-label">
                <Palette size={18} />
                <div className="label-text">
                  <span>Custom Accent</span>
                  <p>{accentColor.toUpperCase()}</p>
                </div>
              </div>
              <button 
                className={`color-preview-trigger ${isPickerOpen ? 'active' : ''}`}
                style={{ backgroundColor: accentColor }}
                onClick={() => setIsPickerOpen(!isPickerOpen)}
              >
                <div className="inner-glow" />
              </button>
            </div>

            {isPickerOpen && (
              <div className="integrated-picker-container">
                <div 
                  className="sv-palette"
                  style={{ backgroundColor: `hsl(${hsv.h}, 100%, 50%)`, touchAction: 'none' }}
                  onPointerDown={(e) => {
                    const rect = e.currentTarget.getBoundingClientRect();
                    const target = e.currentTarget;
                    const update = (me) => {
                      const s = Math.max(0, Math.min(100, ((me.clientX - rect.left) / rect.width) * 100));
                      const v = Math.max(0, Math.min(100, (1 - (me.clientY - rect.top) / rect.height) * 100));
                      updateColorFromHsv(hsv.h, s, v);
                    };
                    target.setPointerCapture(e.pointerId);
                    update(e);
                    const onMove = (m) => update(m);
                    const onUp = (u) => {
                      target.releasePointerCapture(u.pointerId);
                      target.removeEventListener('pointermove', onMove);
                      target.removeEventListener('pointerup', onUp);
                    };
                    target.addEventListener('pointermove', onMove);
                    target.addEventListener('pointerup', onUp);
                  }}
                >
                  <div className="sv-gradient-white" />
                  <div className="sv-gradient-black" />
                  <div className="sv-cursor" style={{ left: `${hsv.s}%`, top: `${100 - hsv.v}%` }} />
                </div>
                
                <div className="hue-slider-container">
                  <input 
                    type="range" min="0" max="360" value={hsv.h}
                    className="hue-slider"
                    onChange={(e) => updateColorFromHsv(parseInt(e.target.value), hsv.s, hsv.v)}
                  />
                </div>

                <div className="picker-controls-row">
                  <div className="hex-input-wrapper glass">
                    <span>#</span>
                    <input 
                      type="text" 
                      value={accentColor.replace('#', '')} 
                      onChange={handleHexInput}
                      placeholder="FFFFFF"
                      maxLength={6}
                    />
                  </div>
                  <button className="reset-theme-btn glass" onClick={handleReset}>
                    Reset Default
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </section>

      <footer className="brand-footer">
        <img src="/logo.png" alt="Pulse" className="brand-footer-logo" />
        <h2>Pulse</h2>
        <p>Version 1.0.0</p>
        <p className="made-by">
          Made with ❤️ by <a href="https://itsashutoshpathak.vercel.app/" target="_blank" rel="noopener noreferrer">
            Ashutosh Pathak
          </a>
        </p>
      </footer>
    </div>
  );
}
