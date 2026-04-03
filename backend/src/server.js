const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const connectDB = require('./config/db');
const taskRoutes = require('./routes/taskRoutes');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Enable CORS and JSON body parsing for API requests.
app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', message: 'Backend is running' });
});

app.use('/api/tasks', taskRoutes);

// Fallback error handler for unexpected runtime errors.
app.use((_err, _req, res, _next) => {
  res.status(500).json({ message: 'Server error.' });
});

const startServer = async () => {
  try {
    await connectDB();
    console.log('Database connected.');
  } catch (error) {
    // Keep API booting so health and non-DB endpoints still respond.
    console.warn('Database connection failed. Starting API without DB.');
    console.warn(error.message);
  }

  app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
  });
};

startServer();
