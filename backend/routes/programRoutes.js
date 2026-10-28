const express = require('express');
const { listPrograms, getProgramById } = require('../controller/programController');
const { registerForProgram } = require('../controller/registrationController');
const { submitFeedback } = require('../controller/feedbackController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', listPrograms);
router.get('/:id', getProgramById);
router.post('/:id/register', protect, registerForProgram);
router.post('/:id/feedback', protect, submitFeedback);

module.exports = router;
