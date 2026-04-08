const logger = require('../utils/logger');

/**
 * Logs every incoming HTTP request with method, path, userId (if auth'd), and response time.
 */
module.exports = function requestLogger(req, res, next) {
  const start = Date.now();

  res.on('finish', () => {
    logger.info('request', {
      method:   req.method,
      path:     req.path,
      status:   res.statusCode,
      ms:       Date.now() - start,
      userId:   req.user?.userId || null,
      ip:       req.ip,
    });
  });

  next();
};
