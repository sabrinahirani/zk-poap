require('dotenv').config(); // load api key

const axios = require('axios');

const apiKey = process.env.API_KEY;
const endpoint = `https://gateway-arbitrum.network.thegraph.com/api/${apiKey}/subgraphs/id/J4XbkvmPeCwBstAGXFwvWih4TFfmcp5xbmpXLaNeSBtp`;

const query = `
{
  events(where: { id: "14" }) {
    tokenCount
    tokens {
      owner {
        id
      }
    }
  }
}
`;

axios.post(endpoint, { query })
  .then(response => {
    console.log('Response:', response.data);
  })
  .catch(error => {
    console.error('Error:', error.message);
  });
