import React from 'react';
import { Box, Heading, HStack, Icon } from '@chakra-ui/react';
import { CloseIcon } from '@chakra-ui/icons';

function Failure() {
  return (
    <Box className='home'>
      <Heading size='xl'>Failure</Heading>
      <Icon as={CloseIcon} boxSize={8} color='red.500' mt={6} />
    </Box>
  );
}

export default Failure;