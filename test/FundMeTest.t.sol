// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.19;
// 2. Imports

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    // setUp will be called in each test function
    // providing a separate and fresh instance of the FundMe contract for each test to ensure tests are independent.
    function setUp() external {
        //me -> fundmetest ->fundme
        //so the owner is test, not me
        // fundMe = new FundMe(0xCf45E7346f604C883cE36AEAc6CaeC5f45f2fe09);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // fundme's i_owner and msg.sender is test's address
        // Always look at where and how function or contract is being called 
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        // i_owner, msg.sender is Test contract itself
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // function testPriceFeedVersionIsAccurate() public {
    //     uint256 version = fundMe.getVersion();
    //     console.log(version);
    //     assertEq(version, 4);
    // }
}

/*
unit
integration
forked
staging
*/