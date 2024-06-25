import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import { ChakraProvider } from '@chakra-ui/react';
import './styles.scss'

import Home from './components/Home';
import Success from './components/Success';
import Failure from './components/Failure';

function App() {
  return (
    <ChakraProvider>
      <Router>
        <Routes>
          <Route path="*" element={<Home />} />
          <Route path="/success" element={<Success />} />
          <Route path="/failure" element={<Failure />} />
        </Routes>
      </Router>
    </ChakraProvider>
  );
}

export default App;