const Program = require('../models/programSchema');
const Registration = require('../models/registrationSchema');
const asyncHandler = require('../utils/asyncHandler');
const { createRegistrationNotification } = require('../services/notificationService');

exports.registerForProgram = asyncHandler(async (req, res) => {
  const programId = req.params.id;
  const program = await Program.findOne({ id: programId });
  if (!program) {
    return res.status(404).json({ message: 'Program not found' });
  }

  const already = await Registration.findOne({ user: req.user._id, programId });
  if (already) {
    return res.status(409).json({ message: 'You are already registered for this program' });
  }

  const updated = await Program.findOneAndUpdate(
    { id: programId, $expr: { $lt: ['$registered', '$capacity'] } },
    { $inc: { registered: 1 } },
    { new: true }
  );
  if (!updated) {
    return res.status(409).json({ message: 'Event full' });
  }

  try {
    await Registration.create({ user: req.user._id, programId });
  } catch (error) {
    await Program.findOneAndUpdate({ id: programId }, { $inc: { registered: -1 } });
    if (error.code === 11000) {
      return res.status(409).json({ message: 'You are already registered for this program' });
    }
    throw error;
  }

  await createRegistrationNotification(req.user._id, updated);

  res.status(201).json({
    message: 'Registration confirmed',
    program: updated,
  });
});

exports.listMyRegistrations = asyncHandler(async (req, res) => {
  const registrations = await Registration.find({ user: req.user._id }).sort({
    createdAt: -1,
  });
  const programIds = registrations.map((r) => r.programId);
  const programs = await Program.find({ id: { $in: programIds } });
  const byId = Object.fromEntries(programs.map((p) => [p.id, p]));

  res.status(200).json(
    registrations.map((r) => ({
      id: r._id.toString(),
      programId: r.programId,
      registeredAt: r.createdAt,
      program: byId[r.programId] || null,
    }))
  );
});
