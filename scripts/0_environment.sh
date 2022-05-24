#! /bin/bash

read -p "Deployer PK: " PK
read -p "RPC URL: " RPCURL

export PRIVATE_KEY=$PK
export RPCURL=$RPCURL

