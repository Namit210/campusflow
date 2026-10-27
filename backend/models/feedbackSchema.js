const mongoose = require('mongoose');

const feedbackSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    programId: { type: String, required: true },
    rating: { type: Number, required: true, min: 1, max: 5 },
    category: {
      type: String,
      required: true,
      enum: [
        'Content',
        'Speaker / Instructor',
        'Venue / Platform',
        'Organisation',
        'Other',
      ],
    },
    email: { type: String, required: true, lowercase: true, trim: true },
    comment: {
      type: String,
      required: true,
      minlength: [10, 'Please write at least 10 characters'],
      maxlength: [300, 'Feedback cannot exceed 300 characters'],
    },
  },
  { timestamps: true }
);

feedbackSchema.set('toJSON', {
  transform(_doc, ret) {
    ret.id = ret._id.toString();
    delete ret._id;
    delete ret.__v;
    return ret;
  },
});

const Feedback = mongoose.model('Feedback', feedbackSchema);

module.exports = Feedback;
