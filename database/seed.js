const path = require('path');
const backendNodeModulesPath = path.resolve(__dirname, '../backend/node_modules');

const requireFromLocalOrBackend = (moduleName) => {
  try {
    return require(moduleName);
  } catch (_error) {
    return require(path.join(backendNodeModulesPath, moduleName));
  }
};

// Always use backend's mongoose so models and connection share one instance.
const mongoose = require(path.join(backendNodeModulesPath, 'mongoose'));
const dotenv = requireFromLocalOrBackend('dotenv');

dotenv.config({ path: path.resolve(__dirname, '../backend/.env') });

const Job = require('../backend/src/models/Job');

const seedJobs = [
  {
    title: 'Construction Worker',
    description: 'Assist with concrete work and site preparation.',
    location: 'Noida',
    wage: 'Rs. 700/day',
  },
  {
    title: 'Electrician Helper',
    description: 'Support electrical installation team for housing projects.',
    location: 'Delhi',
    wage: 'Rs. 750/day',
  },
  {
    title: 'Painter',
    description: 'Interior and exterior paint work for commercial buildings.',
    location: 'Ghaziabad',
    wage: 'Rs. 650/day',
  },
];

const runSeed = async () => {
  try {
    if (!process.env.MONGO_URI) {
      throw new Error('MONGO_URI is missing in backend/.env');
    }

    await mongoose.connect(process.env.MONGO_URI);
    await Job.deleteMany({});
    await Job.insertMany(seedJobs);
    console.log('Seed complete: jobs inserted');
  } catch (error) {
    console.error('Seed failed:', error.message);
  } finally {
    await mongoose.connection.close();
  }
};

runSeed();
