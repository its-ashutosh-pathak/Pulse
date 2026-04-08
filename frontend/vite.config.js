import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['logo.png', 'pwa-512x512.png'],
      devOptions: {
        enabled: true, // enable SW in dev for testing
      },

      // ── Web App Manifest ─────────────────────────────────────────────────────
      manifest: {
        name: 'Pulse',
        short_name: 'Pulse',
        description: 'A premium, self-hosted music streaming app powered by YouTube Music.',
        theme_color: '#0d0d14',
        background_color: '#0d0d14',
        display: 'standalone',
        orientation: 'portrait-primary',
        scope: '/',
        start_url: '/',
        id: '/',
        categories: ['music', 'entertainment'],
        icons: [
          {
            src: 'pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png',
          },
          {
            src: 'pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png',
          },
          {
            src: 'pwa-maskable-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'maskable',
          },
        ],
        screenshots: [],
        shortcuts: [
          {
            name: 'Search Music',
            url: '/search',
            description: 'Search for songs and artists',
          },
          {
            name: 'My Library',
            url: '/library',
            description: 'Browse your saved playlists',
          },
        ],
      },

      // ── Workbox Service Worker Config ────────────────────────────────────────
      workbox: {
        // Pre-cache all Vite build assets (JS, CSS, HTML)
        globPatterns: ['**/*.{js,css,html,png,svg,ico,woff,woff2}'],

        // Runtime caching rules
        runtimeCaching: [
          // App shell — cache-first (fast loads after first visit)
          {
            urlPattern: ({ request }) => request.destination === 'document',
            handler: 'NetworkFirst',
            options: {
              cacheName: 'pulse-pages',
              networkTimeoutSeconds: 3,
              expiration: { maxEntries: 10, maxAgeSeconds: 86400 },
            },
          },

          // Google Fonts — stale-while-revalidate
          {
            urlPattern: /^https:\/\/fonts\.(googleapis|gstatic)\.com/,
            handler: 'StaleWhileRevalidate',
            options: {
              cacheName: 'pulse-fonts',
              expiration: { maxEntries: 20, maxAgeSeconds: 60 * 60 * 24 * 365 },
            },
          },

          // Thumbnails / album art — cache-first (images rarely change)
          {
            urlPattern: /^https:\/\/(lh3\.googleusercontent\.com|i\.ytimg\.com|yt3\.ggpht\.com)/,
            handler: 'CacheFirst',
            options: {
              cacheName: 'pulse-thumbnails',
              expiration: { maxEntries: 500, maxAgeSeconds: 60 * 60 * 24 * 30 }, // 30 days
            },
          },

          // Our own API (metadata/search) — network-first, short cache
          {
            urlPattern: ({ url }) => url.pathname.startsWith('/api/'),
            handler: 'NetworkFirst',
            options: {
              cacheName: 'pulse-api',
              networkTimeoutSeconds: 5,
              expiration: { maxEntries: 100, maxAgeSeconds: 300 }, // 5 min
              // Do NOT cache streaming endpoints
              plugins: [],
            },
          },

          // Audio streams — NEVER cache (too large, always network)
          {
            urlPattern: ({ url }) => url.pathname.includes('/play/') || url.hostname.includes('piped'),
            handler: 'NetworkOnly',
          },
        ],

        // Skip waiting so new SW activates immediately
        skipWaiting: true,
        clientsClaim: true,

        // Offline fallback page
        navigateFallback: '/offline.html',
        navigateFallbackDenylist: [/^\/api\//],
      },
    }),
  ],
});
