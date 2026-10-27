const Notification = require('../models/notificationSchema');
const asyncHandler = require('../utils/asyncHandler');

exports.listNotifications = asyncHandler(async (req, res) => {
  const items = await Notification.find({ user: req.user._id }).sort({ createdAt: -1 });
  const unreadCount = items.filter((n) => !n.read).length;
  res.status(200).json({ unreadCount, notifications: items });
});

exports.markRead = asyncHandler(async (req, res) => {
  const item = await Notification.findOne({
    _id: req.params.id,
    user: req.user._id,
  });
  if (!item) {
    return res.status(404).json({ message: 'Notification not found' });
  }
  item.read = true;
  await item.save();
  res.status(200).json(item);
});

exports.markAllRead = asyncHandler(async (req, res) => {
  await Notification.updateMany({ user: req.user._id, read: false }, { read: true });
  const items = await Notification.find({ user: req.user._id }).sort({ createdAt: -1 });
  res.status(200).json({ unreadCount: 0, notifications: items });
});
