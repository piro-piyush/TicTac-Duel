const PORT = Number(process.env.PORT) || 3000;

const HOST = process.env.HOST || '0.0.0.0';

const NODE_ENV = process.env.NODE_ENV || 'development';

const MONGODB_URI = process.env.MONGODB_URI;

if (!MONGODB_URI) {
    throw new Error('MONGODB_URI is not defined');
}

export {
    HOST,
    MONGODB_URI,
    NODE_ENV,
    PORT
};
