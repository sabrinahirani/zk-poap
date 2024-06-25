import React from 'react';
import { Box, Heading, HStack, Icon } from '@chakra-ui/react';
import { IoCheckmark } from "react-icons/io5";

function Success() {
  return (
    <Box className='home'>
      <Heading size='xl'>Success</Heading>
      <Icon as={IoCheckmark} boxSize={12} color='green.500' mt={6} />
    </Box>
  );
}

export default Success;