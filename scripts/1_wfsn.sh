#! /bin/bash

forge create \
src/WFSN.sol:WFSN \
--rpc-url $RPCURL \
--private-key $PRIVATE_KEY \
--legacy \
--gas-price 3gwei

