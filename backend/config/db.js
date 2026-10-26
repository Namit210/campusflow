const mongoose = require('mongoose');

const connectDb = async (uri) => {
  mongoose.set('strictQuery', true);
  await mongoose.connect(uri);
};

module.exports = connectDb;
