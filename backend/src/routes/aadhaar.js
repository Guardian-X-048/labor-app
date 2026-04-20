const express = require('express');

const User = require('../models/User');
const auth = require('../middleware/auth');

const router = express.Router();

router.post('/verify', auth, async (req, res) => {
  try {
    const { aadhaarNumber } = req.body;

    if (!aadhaarNumber || aadhaarNumber.length !== 12) {
      return res.status(400).json({ message: 'Valid 12-digit Aadhaar number is required' });
    }

    const user = await User.findByIdAndUpdate(
      req.user.id,
      { aadhaarNumber, aadhaarVerified: true },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    return res.json({
      message: 'Aadhaar verified (mock)',
      user: {
        id: user._id,
        aadhaarVerified: user.aadhaarVerified,
        aadhaarNumber: user.aadhaarNumber,
      },
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
});

module.exports = router;
