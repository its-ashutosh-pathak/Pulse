const { auth }        = require('../config/firebase');
const { createError } = require('../utils/errorResponse');
const logger          = require('../utils/logger');

/**
 * Verifies the Firebase ID token from the Authorization header.
 * Attaches req.user = { userId, email } on success.
 */
module.exports = async function authMiddleware(req, res, next) {
  // Support token via Authorization header OR ?token= query param
  // The ?token= approach is required for <audio src> tags which cannot set headers
  const header = req.headers.authorization;
  const queryToken = req.query.token;

  const rawToken = header?.startsWith('Bearer ') ? header.split(' ')[1] : queryToken;

  if (!rawToken) {
    return next(createError(401, 'AUTH_REQUIRED', 'Authorization header missing'));
  }
  try {
    const decoded = await auth.verifyIdToken(rawToken);
    req.user = {
      userId: decoded.uid,
      email:  decoded.email || '',
    };
    next();
  } catch (e) {
    logger.warn('auth_token_failed', { code: e.code, message: e.message });
    const code = e.code === 'auth/id-token-expired' ? 'TOKEN_EXPIRED' : 'TOKEN_INVALID';
    return next(createError(401, code, 'Authentication failed'));
  }
};
