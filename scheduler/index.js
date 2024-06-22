const axios = require('axios');
const cron = require('node-cron');

async function updateSmartContract() {
  // TODO 
}

// schedule
cron.schedule('59 11 * * *', () => {
  console.log('Updating POAP Holders...');
  updateSmartContract();
  console.log()
}, {
  timezone: 'America/New_York'
});
