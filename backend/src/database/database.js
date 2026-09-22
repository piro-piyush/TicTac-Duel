const mongoose = require('mongoose');
const {
  MONGODB_URI
} = require('../config/env');
const Logger = require('../core/utils/logger');

async function connectDatabase() {
  if (!MONGODB_URI) {
    throw new Error('MONGODB_URI is not defined');
  }

  await mongoose.connect(MONGODB_URI);

  Logger.success('MongoDB connected');
}

module.exports = connectDatabase;