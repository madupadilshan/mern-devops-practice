const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const connectDB = require('./config/db');
const taskRoutes = require('./routes/taskRoutes');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', message: 'Backend is running' });
});

app.use('/api/tasks', taskRoutes);

app.use((_err, _req, res, _next) => {
  res.status(500).json({ message: 'Server error.' });
});

const startServer = async () => {
  await connectDB();
  app.listen(PORT);
};

startServer();
