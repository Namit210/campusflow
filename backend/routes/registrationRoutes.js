const express = require('express');
const { listMyRegistrations } = require('../controller/registrationController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', protect, listMyRegistrations);

module.exports = router;
