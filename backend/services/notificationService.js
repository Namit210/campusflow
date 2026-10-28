const Notification = require('../models/notificationSchema');

const seedWelcomeNotifications = async (userId) => {
  await Notification.insertMany([
    {
      user: userId,
      title: 'New Announcement',
      message: "Campus Innovation Day is next week. Don't forget to register!",
      icon: 'campaign',
    },
    {
      user: userId,
      title: 'Feedback Request',
      message: "We'd love to hear your thoughts about the Career Skills Bootcamp.",
      icon: 'rate_review',
    },
    {
      user: userId,
      title: 'Event Reminder',
      message: 'Tech & Product Meet is tomorrow at 4:00 PM.',
      icon: 'notifications_active',
      read: true,
    },
    {
      user: userId,
      title: 'Program Update',
      message: 'New resources were added to the AI & Future Skills program.',
      icon: 'menu_book',
      read: true,
    },
  ]);
};

const createRegistrationNotification = async (userId, program) => {
  return Notification.create({
    user: userId,
    title: 'Event Registration Confirmed',
    message: `You are registered for ${program.title} on ${program.date}.`,
    icon: 'event_available',
  });
};

module.exports = {
  seedWelcomeNotifications,
  createRegistrationNotification,
};
