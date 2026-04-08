/**
 * Standard error response helpers.
 * All API errors must go through these to maintain a consistent shape.
 */

/**
 * Creates an Error with status and code attached.
 * Throw this from services/repositories — the global error handler will format it.
 *
 * @param {number} status  - HTTP status code
 * @param {string} code    - Machine-readable error code (e.g. 'STREAM_FAILED')
 * @param {string} message - Human-readable message
 */
function createError(status, code, message) {
  const err = new Error(message);
  err.status = status;
  err.code   = code;
  return err;
}

/**
 * Builds the standard JSON error body.
 * Used directly in the global error handler middleware.
 */
function errorBody(code, message) {
  return { success: false, error: code, message };
}

/**
 * Builds the standard JSON success body.
 */
function successBody(data, extras = {}) {
  return { success: true, data, ...extras };
}

module.exports = { createError, errorBody, successBody };
