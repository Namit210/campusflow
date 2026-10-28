const express = require('express');
const {
  signup,
  login,
  getMe,
  updateMe,
  deleteMe,
} = require('../controller/authController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/signup', signup);
router.post('/login', login);
router.get('/me', protect, getMe);
router.put('/me', protect, updateMe);
router.delete('/me', protect, deleteMe);

module.exports = router;
