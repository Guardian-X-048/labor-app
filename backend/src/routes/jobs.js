const express = require('express');

const Job = require('../models/Job');
const auth = require('../middleware/auth');

const router = express.Router();

router.get('/', async (_req, res) => {
  try {
    const jobs = await Job.find().sort({ createdAt: -1 });
    return res.json(jobs);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

router.post('/', auth, async (req, res) => {
  try {
    const { title, description, location, wage } = req.body;
    if (!title || !description || !location || !wage) {
      return res
        .status(400)
        .json({ message: 'title, description, location and wage are required' });
    }

    const job = await Job.create({
      title,
      description,
      location,
      wage,
      postedBy: req.user.id,
    });

    return res.status(201).json(job);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

module.exports = router;
