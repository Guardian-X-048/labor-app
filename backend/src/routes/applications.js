const express = require('express');
const mongoose = require('mongoose');

const Application = require('../models/Application');
const Job = require('../models/Job');
const auth = require('../middleware/auth');

const router = express.Router();

router.post('/', auth, async (req, res) => {
  try {
    if (req.user.role !== 'worker') {
      return res.status(403).json({ message: 'Only workers can apply to jobs' });
    }

    const { jobId } = req.body;
    if (!jobId || !mongoose.Types.ObjectId.isValid(jobId)) {
      return res.status(400).json({ message: 'Valid jobId is required' });
    }

    const job = await Job.findById(jobId);
    if (!job) {
      return res.status(404).json({ message: 'Job not found' });
    }

    const existing = await Application.findOne({ job: jobId, worker: req.user.id });
    if (existing) {
      return res.status(409).json({ message: 'You have already applied to this job' });
    }

    const application = await Application.create({ job: jobId, worker: req.user.id });
    return res.status(201).json(application);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

router.get('/my', auth, async (req, res) => {
  try {
    if (req.user.role !== 'worker') {
      return res.status(403).json({ message: 'Only workers can view their applications' });
    }

    const applications = await Application.find({ worker: req.user.id })
      .populate('job')
      .sort({ createdAt: -1 });

    return res.json(applications);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

router.get('/job/:jobId', auth, async (req, res) => {
  try {
    if (req.user.role !== 'employer') {
      return res.status(403).json({ message: 'Only employers can view applicants' });
    }

    const { jobId } = req.params;
    if (!mongoose.Types.ObjectId.isValid(jobId)) {
      return res.status(400).json({ message: 'Invalid job id' });
    }

    const job = await Job.findById(jobId);
    if (!job) {
      return res.status(404).json({ message: 'Job not found' });
    }

    if (job.postedBy?.toString() !== req.user.id) {
      return res.status(403).json({ message: 'You can only view applicants for your jobs' });
    }

    const applications = await Application.find({ job: jobId })
      .populate({
        path: 'worker',
        select: 'name phone aadhaarVerified',
      })
      .sort({ createdAt: -1 });

    return res.json(applications);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

router.patch('/:applicationId/status', auth, async (req, res) => {
  try {
    if (req.user.role !== 'employer') {
      return res.status(403).json({ message: 'Only employers can update application status' });
    }

    const { applicationId } = req.params;
    const { status } = req.body;

    if (!mongoose.Types.ObjectId.isValid(applicationId)) {
      return res.status(400).json({ message: 'Invalid application id' });
    }

    if (!['accepted', 'rejected', 'pending'].includes(status)) {
      return res.status(400).json({ message: 'status must be accepted, rejected, or pending' });
    }

    const application = await Application.findById(applicationId).populate('job');
    if (!application) {
      return res.status(404).json({ message: 'Application not found' });
    }

    if (application.job?.postedBy?.toString() !== req.user.id) {
      return res.status(403).json({ message: 'You can only manage applications for your jobs' });
    }

    application.status = status;
    await application.save();

    return res.json(application);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

module.exports = router;
