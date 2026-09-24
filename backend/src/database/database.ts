import mongoose from 'mongoose';

import { MONGODB_URI } from '../config/env';
import Logger from '../core/utils/logger';

async function connectDatabase(): Promise<void> {
  if (!MONGODB_URI) {
    throw new Error('MONGODB_URI is not defined');
  }

  await mongoose.connect(MONGODB_URI);

  Logger.success('MongoDB connected');
}

export default connectDatabase;