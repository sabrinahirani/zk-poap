import React, { useState, useEffect } from 'react';
import { Box, Heading, HStack, Input, Button } from '@chakra-ui/react';
import { useNavigate } from 'react-router-dom';
import * as snarkjs from 'snarkjs';
import axios from 'axios';

const ethers = require("ethers")

function Home() {
  const [wallet, setWallet] = useState(null);
  const [privateKey, setPrivateKey] = useState('');
  const [eventId, setEventId] = useState('');

  const navigate = useNavigate();

  const convertPrivateKey = (hexKey) => {
    if (hexKey.length !== 64) {
      navigate('/error');
    }
    const pk = [];
    for (let i = 0; i < 4; i++) {
      const hexPart = hexKey.slice(i * 16, (i + 1) * 16);
      const decimalPart = BigInt(`0x${hexPart}`).toString();
      pk.push(decimalPart);
    }
    return pk;
  };

  const handleChangePrivateKey = (event) => {
    setPrivateKey(event.target.value);
  };

  const handleChangeEventId = (event) => {
    setEventId(event.target.value);
  };

  const handleConnect = async () => {

    try {

      const newWallet = new ethers.Wallet(privateKey);

      // ensure that address is valid
      await newWallet.getAddress(); 

      setWallet(newWallet);

    } catch (error) {

      navigate('/error');

    }
  };

  const handleSubmit = async() => {

    const config = require('../config.json');

    const apiKey = config.API_KEY;
    const endpoint = `https://gateway-arbitrum.network.thegraph.com/api/${apiKey}/subgraphs/id/J4XbkvmPeCwBstAGXFwvWih4TFfmcp5xbmpXLaNeSBtp`;

    // demo: ETHDenver 2019 POAP (event id = 14)
    const query = `
      {
        events(where: { id: "${eventId}" }) {
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
      .then(async(response) => {
        
        let addresses = []
        const tokens = response.data["data"]["events"]["0"]["tokens"];
        for (var i = 0; i < tokens.length; i++) {
          addresses.push(tokens[i].owner.id);
        }

        const input = {
          pk: convertPrivateKey(privateKey),
          addr: addresses
        };
  
        const { proof, publicSignals } = await snarkjs.groth16.fullProve(
          input,
          'zkPOAP.wasm',
          'zkPOAP_final.zkey'
        );

      const vkey = await fetch('verification_key.json').then(res => res.json());
      const isValid = await snarkjs.groth16.verify(vkey, publicSignals, proof);

    if (isValid) {
      navigate('/success');
    } else {
      navigate('/failure');
    }

      })
      .catch(error => {

        navigate('/error');

      });
  };

  if (!wallet) {
    return (
      <Box className='home'>
        <HStack className='heading' spacing={4}>
          <Heading size='xl'>zkPOAP</Heading>
        </HStack>
        <Input
          variant='flushed'
          borderColor='purple.500'
          placeholder='Private Key'
          onChange={handleChangePrivateKey}
          width='200px'
          mt={4}
        />
        <Button
          variant='outline'
          colorScheme='purple'
          onClick={handleConnect}
          mt={4}
        >
          Connect
        </Button>
      </Box>
    );
  }

  return (
    <Box className='home'>
      <HStack className='heading' spacing={4}>
        <Heading size='xl'>zkPOAP</Heading>
      </HStack>
      <Input
        variant='flushed'
        borderColor='purple.500'
        placeholder='Event Id'
        onChange={handleChangeEventId}
        width='200px'
        mt={4}
      />
      <Button
        variant='outline'
        colorScheme='purple'
        onClick={handleSubmit}
        mt={4}
      >
        Validate
      </Button>
    </Box>
  );
}

export default Home;
