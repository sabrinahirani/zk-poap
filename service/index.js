require('dotenv').config();

const express = require('express');
const axios = require('axios');

const app = express();
const port = process.env.PORT || 3000;

const apiKey = process.env.API_KEY;
const endpoint = `https://gateway-arbitrum.network.thegraph.com/api/${apiKey}/subgraphs/id/J4XbkvmPeCwBstAGXFwvWih4TFfmcp5xbmpXLaNeSBtp`;
if (!apiKey) {
  console.error('No API KEY');
  process.exit(1);
}

// ETHDenver 2019 POAP (event id = 14)
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

// get POAP holders
app.get('/', async (req, res) => {

    // query the graph
    axios.post(endpoint, { query })
    .then(response => {
    
        // TODO handle
      console.log('Response:', response.data);
    })
    .catch(error => {

        // TODO handle
      console.error('Error:', error.message);
    });
});

// start server
app.listen(port, () => {
  console.log(`listening on http://localhost:${port}...`);
});
