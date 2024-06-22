// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract zkPOAP {

    using Chainlink for Chainlink.Request;

    event RequestMade(bytes32 indexed requestId);
    event RequestProcessed(bytes32 indexed requestId);

    bytes32 private jobId;
    uint256 private fee;

    constructor() {

        // reference: https://docs.chain.link/resources/link-token-contracts
        _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789); // sepolia

        // reference: https://docs.chain.link/any-api/testnet-oracles
        _setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD); // sepolia

        jobId = "7da2702f37fd48e5b1b9a5715e3509b6"; // GET > bytes

        fee = (1 * LINK_DIVISIBILITY) / 10; 
    }

    function makeRequest(string memory _url, uint256 _eventId) public nonReentrant {
        Chainlink.Request memory request = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector); //build request

        // to external adapter
        request._add("get", _url);
        request._add("id", _eventId);

        // make request
        bytes32 requestId = _sendChainlinkRequest(request, fee);
        emit RequestMade(requestId);
    }

    function fulfill(bytes32 requestId, bytes memory result) public nonReentrant recordChainlinkFulfillment(requestId)  {
        
        emit RequestProcessed(requestId);

        // get response
        // TODO go to verifier
    }

}
