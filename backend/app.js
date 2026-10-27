const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const programRoutes = require('./routes/programRoutes');
const registrationRoutes = require('./routes/registrationRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (_req, res) => {
  res.json({ name: 'CampusFlow API', status: 'ok' });
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

app.use('/auth', authRoutes);
app.use('/programs', programRoutes);
app.use('/registrations', registrationRoutes);
app.use('/notifications', notificationRoutes);

app.use((req, res) => {
  res.status(404).json({ message: `Route ${req.method} ${req.path} not found` });
});

app.use(errorHandler);

module.exports = app;
