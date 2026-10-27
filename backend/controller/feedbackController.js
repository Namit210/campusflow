const Program = require('../models/programSchema');
const Feedback = require('../models/feedbackSchema');
const asyncHandler = require('../utils/asyncHandler');

exports.submitFeedback = asyncHandler(async (req, res) => {
  const programId = req.params.id;
  const { rating, category, email, comment } = req.body || {};

  const program = await Program.findOne({ id: programId });
  if (!program) {
    return res.status(404).json({ message: 'Program not found' });
  }

  if (!rating || !category || !email || !comment) {
    return res.status(400).json({ message: 'rating, category, email and comment are required' });
  }

  const entry = await Feedback.create({
    user: req.user?._id,
    programId,
    rating,
    category,
    email,
    comment,
  });

  res.status(201).json({
    message: 'Thank you for your feedback!',
    feedback: entry,
  });
});
