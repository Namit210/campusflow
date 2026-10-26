require('dotenv').config();
const app = require('./app');
const connectDb = require('./config/db');
const seedPrograms = require('./seed/seedPrograms');

const PORT = process.env.PORT || 3000;

const start = async () => {
  if (!process.env.MONGODB_URI) {
    console.error('MONGODB_URI is not set');
    process.exit(1);
  }
  if (!process.env.JWT_SECRET) {
    console.error('JWT_SECRET is not set');
    process.exit(1);
  }

  await connectDb(process.env.MONGODB_URI);
  await seedPrograms();

  app.listen(PORT, () => {
    console.log(`CampusFlow API running on port ${PORT}`);
  });
};

start().catch((error) => {
  console.error('Failed to start server', error);
  process.exit(1);
});
