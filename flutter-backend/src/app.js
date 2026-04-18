require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const innertubeProxy = require('./routes/innertube.proxy');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors({ origin: true, credentials: true }));
app.use(express.json());
app.use(morgan('dev'));

// Core Proxy Route
app.use('/', innertubeProxy);

// Root success message
app.get('/', (req, res) => res.send('🚀 Pulse Flutter Proxy is Live and Running!'));

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok', proxy: 'active' }));

app.listen(PORT, () => console.log(`🚀 Pulse Flutter Proxy running on port ${PORT}`));
