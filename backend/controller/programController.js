const Program = require('../models/programSchema');
const asyncHandler = require('../utils/asyncHandler');

exports.listPrograms = asyncHandler(async (req, res) => {
  const { category, q } = req.query;
  const filter = {};

  if (category && category !== 'All') {
    filter.category = category;
  }
  if (q) {
    filter.title = { $regex: q, $options: 'i' };
  }

  const programs = await Program.find(filter).sort({ startsInDays: 1, title: 1 });
  res.status(200).json(programs);
});

exports.getProgramById = asyncHandler(async (req, res) => {
  const program = await Program.findOne({ id: req.params.id });
  if (!program) {
    return res.status(404).json({ message: 'Program not found' });
  }
  res.status(200).json(program);
});
