const express = require('express');
const router = express.Router();

// A lightweight CORS proxy for YouTube Music InnerTube API
router.post('/proxy/:endpoint', async (req, res) => {
  try {
    const { endpoint } = req.params;
    const ytUrl = `https://music.youtube.com/youtubei/v1/${endpoint}?key=${req.query.key}&prettyPrint=false`;

    const headers = {
      'Content-Type': 'application/json',
      'User-Agent': req.headers['user-agent'] || 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
      'Origin': 'https://music.youtube.com',
      'Referer': 'https://music.youtube.com/',
      'Accept': '*/*, application/json',
      'Accept-Language': 'en-US,en;q=0.9',
    };

    if (process.env.YOUTUBE_COOKIE) {
      headers['Cookie'] = process.env.YOUTUBE_COOKIE;
    }

    const response = await fetch(ytUrl, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(req.body),
    });

    if (!response.ok) {
      return res.status(response.status).send(await response.text());
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('[proxy]', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Image Proxy
router.get('/proxy-image', async (req, res) => {
  try {
    const { url } = req.query;
    if (!url) return res.status(400).send('Missing url parameter');

    const imageResponse = await fetch(url.replace('http://', 'https://'), {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
      }
    });

    if (!imageResponse.ok) return res.status(imageResponse.status).send('Failed to fetch image');
    
    // Set caching headers
    res.set('Cache-Control', 'public, max-age=86400'); // 24 hours
    res.set('Content-Type', imageResponse.headers.get('content-type') || 'image/jpeg');
    
    const arrayBuffer = await imageResponse.arrayBuffer();
    res.send(Buffer.from(arrayBuffer));
  } catch (error) {
    res.status(500).send('Image proxy error');
  }
});

module.exports = router;
