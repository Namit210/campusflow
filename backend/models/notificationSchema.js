const mongoose = require('mongoose');
const timeAgo = require('../utils/timeAgo');

const notificationSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true },
    message: { type: String, required: true },
    icon: { type: String, default: 'campaign' },
    read: { type: Boolean, default: false },
  },
  { timestamps: true }
);

notificationSchema.set('toJSON', {
  transform(_doc, ret) {
    ret.id = ret._id.toString();
    ret.timeAgo = timeAgo(ret.createdAt);
    delete ret._id;
    delete ret.__v;
    return ret;
  },
});

const Notification = mongoose.model('Notification', notificationSchema);

module.exports = Notification;
