/*
 * use this: https://github.com/0xPARC/circom-ecdsa
 * 
*/

pragma circom 2.0.0;

template CompAddr() {

    signal input k;
    signal input pk;

    signal output att;

    // do this: k * G === pk

}

component main { public [pk] } = CompAddr();