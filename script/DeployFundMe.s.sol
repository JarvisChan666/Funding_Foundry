// SPDX-License-Identifier: UNLICENSED

// This script simplifies deploying FundMe to any Ethereum network by changing network address.
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Create this before broadcasting, this is not a real tx(transaction)
        // We don't spend the gas
        // Before broadcasting: simulate environment
        HelperConfig helperConfig = new HelperConfig();

        // After broadcasting: real transaction
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0xCf45E7346f604C883cE36AEAc6CaeC5f45f2fe09);
        vm.stopBroadcast();
        // Executes and deploy fundme, so fundme's msg.sender and i_owner is DeployFundMe address
        return fundMe;
    }
}
