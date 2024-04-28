// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

// 1. Deploy mocks when we are in local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// MAINNET ETH/USD

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid ==80001) {
            activeNetworkConfig = getPolygonEthConfig();
        }
        else {
            activeNetworkConfig =  getOrCreateAnvilEthConfig();
        }
    }

    // pure: the function won't read and modified contract's state
    // Only return hardcode data ! ! !
    // If return configuration data that depends on a stored value or a state variable, they should be marked as 'view'
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0xCf45E7346f604C883cE36AEAc6CaeC5f45f2fe09
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetEthConfig;
    }

    function getPolygonEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory polygonEthConfig = NetworkConfig({
            priceFeed: 0xF9680D99D6C9589e2a93a78A04A279e509205945
        });
        return polygonEthConfig;
    }

    // Local mock network configuration
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        
        // Return directly if it is exist
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        
        vm.startBroadcast();
        MockV3Aggregator mockPricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPricefeed)
        });
        return anvilConfig;
    }

    // write a linkedlist
    
}
