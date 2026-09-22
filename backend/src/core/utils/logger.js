const {
  NODE_ENV,
} = require('../../config/env');

class Logger {
  static info(message, data) {
    this._log('INFO', message, data);
  }

  static success(message, data) {
    this._log('SUCCESS', message, data);
  }

  static warn(message, data) {
    this._log('WARN', message, data);
  }

  static error(message, error) {
    this._log('ERROR', message, error);
  }

  static debug(message, data) {
    if (NODE_ENV === 'development') {
      this._log('DEBUG', message, data);
    }
  }

  static _log(level, message, data) {
    const timestamp = new Date().toISOString();
    const prefix = `[${timestamp}] [${level}]`;

    if (data !== undefined) {
      console.log(`${prefix} ${message}`, data);
      return;
    }

    console.log(`${prefix} ${message}`);
  }
}

module.exports = Logger;