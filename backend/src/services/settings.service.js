/**
 * settings.service.js
 * Manages per-user streaming/download quality preferences.
 */
const settingsRepo = require('../repositories/settings.repository');
const validate     = require('../utils/validate');

async function getSettings(userId) {
  return settingsRepo.get(userId);
}

async function updateSettings(userId, updates) {
  validate.settings(updates);
  return settingsRepo.update(userId, updates);
}

module.exports = { getSettings, updateSettings };
