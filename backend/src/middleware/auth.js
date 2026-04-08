const { auth }        = require('../config/firebase');
const { createError } = require('../utils/errorResponse');
const logger          = require('../utils/logger');

/**
 * Verifies the Firebase ID token from the Authorization header.
 * Attaches req.user = { userId, email } on success.
 */
module.exports = async function authMiddleware(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return next(createError(401, 'AUTH_REQUIRED', 'Authorization header missing'));
  }

  const token = header.split(' ')[1];
  try {
    const decoded = await auth.verifyIdToken(token);
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
