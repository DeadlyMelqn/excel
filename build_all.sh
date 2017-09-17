#!/bin/bash
# Build TGPKernel for N
git checkout tw70
./build.sh 7
./build.sh 0

# Build TGPKernel for S8Port-NFE
git checkout tw70-s8port
./build.sh 7
./build.sh 0

