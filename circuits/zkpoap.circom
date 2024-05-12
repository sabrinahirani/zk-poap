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

template FindInQueryAddr(n) {

    signal input k;
    signal input pk[n];

    signal output att;

    for (var i = 0; i < n; i++) {
        component comp = CompAddr();
        // TODO
    }

}

component main { public [pk] } = CompAddr();