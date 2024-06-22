pragma circom 2.0.2;

include "./node_modules/circomlib/circuits/mimcsponge.circom";
include "./node_modules/circomlib/circuits/bitify.circom";
include "./circom-ecdsa/eth_addr.circom";

/*
  Inputs:
  - addr1 (pub)
  - addr2 (pub)
  - addr3 (pub)
  - msg (pub)
  - privkey

  Intermediate values:
  - myAddr (supposed to be addr of privkey)
  
  Output:
  - msgAttestation
  
  Prove:
  - PrivKeyToAddr(privkey) == myAddr
  - (x - addr1)(x - addr2)(x - addr3) == 0
  - msgAttestation == mimc(msg, privkey)
*/

template Main(n, k, m) {
    assert(n * k >= 256);
    assert(n * (k-1) < 256);

    signal input privkey[k];
    signal input addrs[m];
    signal input msg;

    signal myAddr;

    signal output msgAttestation;

    // check that privkey properly represents a 256-bit number
    component n2bs[k];
    for (var i = 0; i < k; i++) {
        n2bs[i] = Num2Bits(i == k-1 ? 256 - (k-1) * n : n);
        n2bs[i].in <== privkey[i];
    }

    // compute addr
    component privToAddr = PrivKeyToAddr(n, k);
    for (var i = 0; i < k; i++) {
        privToAddr.privkey[i] <== privkey[i];
    }
    myAddr <== privToAddr.addr;

    // verify address is one of the provided
    signal temp[m];
    temp[0] <-- myAddr - addrs[0];
    for (var i = 1; i < m; i++) {
        temp[i] <-- temp[i-1] * (myAddr - addrs[i]);
    }
    0 === temp[m-1];
}

// example instantiation for main circuit
component main {public [addrs, msg]} = Main(64, 4, 3);
