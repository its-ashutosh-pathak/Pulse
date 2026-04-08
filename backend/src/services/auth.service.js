/**
 * auth.service.js
 * Handles post-Firebase-Auth profile sync.
 * Firebase Auth owns signup/login — we only manage the Firestore user profile.
 */
const userRepo = require('../repositories/user.repository');
const logger   = require('../utils/logger');
const validate = require('../utils/validate');

/**
 * Create or sync the Firestore user profile after Firebase Auth signup.
 * Idempotent — safe to call again if network retry occurs.
 */
async function createProfile({ userId, email, name }) {
  validate.profileCreate({ name });

  // Check if profile already exists — return it (idempotent)
  const existing = await userRepo.findById(userId);
  if (existing) {
    logger.info('auth_profile_exists', { userId });
    return existing;
  }

  const now  = new Date();
  const user = {
    userId,
    name:      name.trim(),
    email:     email || '',
    createdAt: now,
    updatedAt: now,
  };

  await userRepo.create(user);
  logger.info('auth_profile_created', { userId });
  return user;
}

/**
 * Fetch a user's safe profile (no sensitive fields).
 */
async function getProfile(userId) {
  return userRepo.findById(userId);
}

module.exports = { createProfile, getProfile };
