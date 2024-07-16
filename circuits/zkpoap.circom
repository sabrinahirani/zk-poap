pragma circom 2.0.2;

include "./node_modules/circomlib/circuits/mimcsponge.circom";
include "./node_modules/circomlib/circuits/bitify.circom";
include "./circom-ecdsa/eth_addr.circom";

template Main(n, k, m) {

    assert(n * k >= 256);
    assert(n * (k-1) < 256);

     // private key
    signal input sk[k];

    // queried ethereum addresses
    signal input addr[m];

    // ensure that private key represents 256-bit number 
    component n2bs[k];
    for (var i = 0; i < k; i++) {
        n2bs[i] = Num2Bits(i == k-1 ? 256 - (k-1) * n : n);
        n2bs[i].in <== sk[i];
    }

    // compute address from private key
    signal skAddr;
    component privToAddr = PrivKeyToAddr(n, k);
    for (var i = 0; i < k; i++) {
        privToAddr.privkey[i] <== sk[i];
    }
    skAddr <== privToAddr.addr;

    // verify that address is one of queried ethereum addresses
    signal matchAddr[m];
    matchAddr[0] <-- (skAddr - addr[0]);
    for (var i = 1; i < m; i++) {
        matchAddr[i] <-- matchAddr[i-1] * (skAddr - addr[i]);
    }
    matchAddr[m-1] === 0;

}

component main {public [addr]} = Main(64, 4, 85); // hardcoded: 85 queried addresses
