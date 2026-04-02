const express = require('express');
const Task = require('../models/Task');

const router = express.Router();

router.get('/', async (_req, res) => {
  try {
    const tasks = await Task.find().sort({ createdAt: -1 });
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch tasks.' });
  }
});

router.post('/', async (req, res) => {
  try {
    const { title } = req.body;
    const normalizedTitle = typeof title === 'string' ? title.trim() : '';

    if (!normalizedTitle) {
      return res.status(400).json({ message: 'Title is required.' });
    }

    const task = await Task.create({ title: normalizedTitle });
    return res.status(201).json(task);
  } catch (error) {
    return res.status(500).json({ message: 'Failed to create task.' });
  }
});

router.patch('/:id/toggle', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({ message: 'Task not found.' });
    }

    task.done = !task.done;
    await task.save();

    return res.json(task);
  } catch (error) {
    return res.status(500).json({ message: 'Failed to update task.' });
  }
});

module.exports = router;
