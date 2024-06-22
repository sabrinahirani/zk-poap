#!/bin/bash

# script for setup and compiling circom circuit 

# exit on error
set -e

# start a new powers of tau ceremony
snarkjs powersoftau new bn128 20 pot20_0000.ptau -v

# contribute to the ceremony
snarkjs powersoftau contribute pot20_0000.ptau pot20_0001.ptau --name="First contribution" -v
snarkjs powersoftau contribute pot20_0001.ptau pot20_0002.ptau --name="Second contribution" -v -e="some random text"

# verify so far
snarkjs powersoftau verify pot20_0002.ptau

# apply a random beacon
snarkjs powersoftau beacon pot20_0002.ptau pot20_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

# prepare phase 2
snarkjs powersoftau prepare phase2 pot20_beacon.ptau pot20_final.ptau -v

# verify final
snarkjs powersoftau verify pot20_final.ptau

# compile circuit
circom circuit.circom --r1cs --wasm --sym

# see circuit info
snarkjs r1cs info circuit.r1cs

# see circuit constraints
snarkjs r1cs print circuit.r1cs circuit.sym

# export r1cs to json
snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
cat circuit.r1cs.json

# generate witness
node circuit_js/generate_witness.js circuit_js/circuit.wasm input.json witness.wtns
snarkjs wtns check circuit.r1cs witness.wtns

# setup groth16
snarkjs groth16 setup circuit.r1cs pot20_final.ptau circuit_0000.zkey

# contribute to phase 2 ceremony
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"

# verify so far
snarkjs zkey verify circuit.r1cs pot20_final.ptau circuit_0002.zkey

# apply a random beacon
snarkjs zkey beacon circuit_0002.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

# verify final
snarkjs zkey verify circuit.r1cs pot20_final.ptau circuit_final.zkey

# export verification key
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# generate proof
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json

# verify proof
snarkjs groth16 verify verification_key.json public.json proof.json

# verifier smart contract
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol

# simulate verification call
snarkjs zkey export soliditycalldata public.json proof.json
