const fs = require('fs');
const path = require('path');
const Program = require('../models/programSchema');

const seedPrograms = async () => {
  const count = await Program.countDocuments();
  if (count > 0) return;

  const file = path.join(__dirname, '..', 'data', 'programs.json');
  const programs = JSON.parse(fs.readFileSync(file, 'utf8'));
  await Program.insertMany(programs);
};

module.exports = seedPrograms;
