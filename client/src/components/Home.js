import React from 'react';
import { Box, Heading, HStack, Input, Button } from '@chakra-ui/react';
import { Link } from 'react-router-dom';

function Home() {
  return (
    <Box className='home'>
      <HStack className='heading' spacing={4}>
        <Heading size='xl'>zkPOAP</Heading>
      </HStack>
      <Input
        variant='flushed'
        borderColor='purple.500'
        placeholder='Event Id'
        width='200px'
        mt={4}
      />
      <Button
        variant='outline'
        colorScheme='purple'
        mt={4}
      >
        Validate
      </Button>
    </Box>
  );
}

export default Home;
