// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.19;
// 2. Imports

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

/// @title FundMe Unit Tests
/// @notice This contract implements tests for the FundMe contract using the Forge framework for Solidity testing.
/// @author jarvischan

contract FundMeTest is Test {
    FundMe public fundMe;

    /// @dev Sets up a new instance of the FundMe contract for each test case.
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    /// @notice Testing that the minimum USD funding amount is set correctly in the FundMe contract.
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    /// @notice Testing that the owner of the FundMe contract is the deployer.
    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    /// @notice Testing that the price feed version called by FundMe is accurate and returning the expected version number.
    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4);
    }
}

/*
unit
integration
forked
staging
*/
