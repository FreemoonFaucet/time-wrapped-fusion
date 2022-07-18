// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/WFSN.sol";


contract WrappedFusionScript is Script {
    function run() external {
        vm.startBroadcast();

        WFSN wfsn = new WFSN();

        vm.stopBroadcast();
    }
}
