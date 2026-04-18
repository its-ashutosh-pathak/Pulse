const express = require('express');
const router = express.Router();
const https = require('https');

// A lightweight CORS proxy for YouTube Music InnerTube API
router.post('/proxy/:endpoint', async (req, res, next) => {
  try {
    const { endpoint } = req.params;
    
    // YouTube Music InnerTube URL
    const ytUrl = `https://music.youtube.com/youtubei/v1/${endpoint}?key=${req.query.key}&prettyPrint=false`;

    // Construct headers, mimicking an Android/Web client
    const headers = {
      'Content-Type': 'application/json',
      'User-Agent': req.headers['user-agent'] || 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
      'Origin': 'https://music.youtube.com',
      'Referer': 'https://music.youtube.com/',
      'Accept': '*/*, application/json',
      'Accept-Language': 'en-US,en;q=0.9',
    };

    // Include the backend yt-dlp cookie if available to prevent Bot blocks on searches
    if (process.env.YOUTUBE_COOKIE) {
      headers['Cookie'] = process.env.YOUTUBE_COOKIE;
    }

    const { body } = req;
    
    const response = await fetch(ytUrl, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      console.error('[Innertube Proxy] Route failed with status', response.status);
      return res.status(response.status).send(await response.text());
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('[Innertube Proxy] Error proxying to YouTube:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
