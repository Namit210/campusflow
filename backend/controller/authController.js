const User = require('../models/userSchema');
const asyncHandler = require('../utils/asyncHandler');
const toUserPayload = require('../utils/userPayload');
const { signToken } = require('../services/tokenService');
const { seedWelcomeNotifications } = require('../services/notificationService');

exports.signup = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body || {};
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Name, email and password are required' });
  }

  const existing = await User.findOne({ email: String(email).toLowerCase().trim() });
  if (existing) {
    return res.status(409).json({ message: 'An account with this email already exists' });
  }

  const user = await User.create({ name, email, password });
  await seedWelcomeNotifications(user._id);

  res.status(201).json({
    message: 'Account created successfully',
    user: toUserPayload(user),
  });
});

exports.login = asyncHandler(async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  const user = await User.findOne({ email: String(email).toLowerCase().trim() }).select(
    '+password'
  );
  if (!user || !(await user.matchPassword(password))) {
    return res.status(401).json({ message: 'Invalid email or password' });
  }

  res.status(200).json({
    token: signToken(user._id),
    user: toUserPayload(user),
  });
});

exports.getMe = asyncHandler(async (req, res) => {
  res.status(200).json({ user: toUserPayload(req.user) });
});

exports.updateMe = asyncHandler(async (req, res) => {
  const { name, email } = req.body || {};
  if (name !== undefined) req.user.name = name;
  if (email !== undefined) req.user.email = email;
  await req.user.save();
  res.status(200).json({ user: toUserPayload(req.user) });
});

exports.deleteMe = asyncHandler(async (req, res) => {
  await req.user.deleteOne();
  res.status(200).json({ message: 'Account deleted successfully' });
});
