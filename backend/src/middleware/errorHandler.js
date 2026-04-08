const logger = require('../utils/logger');
const { errorBody } = require('../utils/errorResponse');

/**
 * Global error handler — must be the LAST middleware registered in app.js.
 * All errors thrown via createError() or next(err) flow through here.
 * Stack traces are logged server-side but NEVER sent to the client.
 */
// eslint-disable-next-line no-unused-vars
module.exports = function errorHandler(err, req, res, next) {
  const status = err.status || 500;
  const code = err.code || 'INTERNAL_ERROR';
  const message = status === 500
    ? 'An internal error occurred'
    : err.message;

  logger.error('request_error', {
    code,
    message: err.message,
    path: req.path,
    method: req.method,
    userId: req.user?.userId || null,
    stack: err.stack,
  });

  res.status(status).json(errorBody(code, message));
};
