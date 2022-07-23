// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/WFSN.sol";


contract WrappedFusionScript is Script {
    address admin = 0x3eC6124e79383f759fC7b411ABFDF4dCB9A67d1A;
    address terms = 0x597BAACa331f343F3652B8C52ba410bd23A08134;

    function run() external {
        vm.startBroadcast();

        WFSN wfsn = new WFSN(admin, terms);

        vm.stopBroadcast();
    }
}