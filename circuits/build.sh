#!/bin/bash

# script for setup and compiling circom circuit 

# exit on error
set -e

CIRCUIT_NAME="zkPOAP"
PROOF_SYSTEM="groth16"

POWER=20
POT="./powers-of-tau/pot${POWER}_final.ptau"

# # ensure powers of tau exists
# if [ ! -f ${POT} ]; then
#   echo "${POT} not found — Running ./powers-of-tau/pot.sh"
#   ./powers-of-tau/pot.sh ${POWER}
# fi

# # compile circuit
# circom ${CIRCUIT_NAME}.circom --r1cs --wasm --sym

# # see circuit info
# snarkjs r1cs info ${CIRCUIT_NAME}.r1cs

# # see circuit constraints
# snarkjs r1cs print ${CIRCUIT_NAME}.r1cs ${CIRCUIT_NAME}.sym

# # generate witness
# node ${CIRCUIT_NAME}_js/generate_witness.js ${CIRCUIT_NAME}_js/${CIRCUIT_NAME}.wasm input.json witness.wtns
# snarkjs wtns check ${CIRCUIT_NAME}.r1cs witness.wtns

# # setup proof system
# snarkjs ${PROOF_SYSTEM} setup ${CIRCUIT_NAME}.r1cs ${POT} ${CIRCUIT_NAME}_0000.zkey

# # contribute to phase 2 ceremony
# snarkjs zkey contribute ${CIRCUIT_NAME}_0000.zkey ${CIRCUIT_NAME}_0001.zkey --name="First Contribution" -v -e="some random text"
# snarkjs zkey contribute ${CIRCUIT_NAME}_0001.zkey ${CIRCUIT_NAME}_0002.zkey --name="Second Contribution" -v -e="some more random text"

# # verify so far
# snarkjs zkey verify ${CIRCUIT_NAME}.r1cs ${POT} ${CIRCUIT_NAME}_0002.zkey

# # apply a random beacon
# snarkjs zkey beacon ${CIRCUIT_NAME}_0002.zkey ${CIRCUIT_NAME}_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

# verify final
snarkjs zkey verify ${CIRCUIT_NAME}.r1cs ${POT} ${CIRCUIT_NAME}_final.zkey

# export verification key
snarkjs zkey export verificationkey ${CIRCUIT_NAME}_final.zkey verification_key.json

# generate proof
snarkjs ${PROOF_SYSTEM} prove ${CIRCUIT_NAME}_final.zkey witness.wtns proof.json public.json

# verify proof
snarkjs ${PROOF_SYSTEM} verify verification_key.json public.json proof.json

# verifier smart contract
snarkjs zkey export solidityverifier ${CIRCUIT_NAME}_final.zkey verifier.sol

# simulate verification call
snarkjs zkey export soliditycalldata public.json proof.json
