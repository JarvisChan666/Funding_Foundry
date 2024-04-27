// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

// 1. Deploy mocks when we are in local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// MAINNET ETH/USD

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    // pure: not read and modified
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0xCf45E7346f604C883cE36AEAc6CaeC5f45f2fe09
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return mainnetEthConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {}
}
