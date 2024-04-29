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
    /// Fundme owner is deploy script
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    /// @notice Testing that the minimum USD funding amount is set correctly in the FundMe contract.
    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    /// @notice Testing that the owner of the FundMe contract is the deployer.
    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.owner(), msg.sender);
    }

    /// @notice Test funding of the contract and balance update.
    /// Only pass in local mock
    function testFundAndBalanceUpdate() public {
        uint256 beforeBalance = address(fundMe).balance;
        uint256 fundAmount = 1e18; // 1 ETH in Wei
        vm.deal(address(this), fundAmount);
        fundMe.fund{value: fundAmount}();

        uint256 afterBalance = address(fundMe).balance;
        assertEq(
            afterBalance,
            beforeBalance + fundAmount,
            "Contract balance should be increased by the fund amount"
        );
    }

    function testFundFailWithNoEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    /// @notice Test funders list is updated after funding.
    function testFunderIsAddedToList() public {
        address funder = address(2); // An example address for funder.
        uint256 fundAmount = 1e18; // 1 ETH in Wei

        vm.deal(funder, fundAmount); // Funder get ETH to fund
        // starts a session where subsequent actions are considered as being performed by the specified account
        vm.startPrank(funder);
        fundMe.fund{value: fundAmount}();
        vm.stopPrank();

        // check if the last funder in the array is the address that just funded
        address lastFunder = fundMe.funders(fundMe.getFunderCount() - 1);
        assertEq(lastFunder, funder, "Funder should be added to funders list");
    }

    function testAddressToAmountFunded() public {
        uint256 fundAmount = 1e18; // 1 ETH in Wei

        fundMe.fund{value: fundAmount}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));

        assertEq(fundAmount, amountFunded);

        // Another way to test, using foundry 'Prank'
        // address funder = address(2); // An example address for funder.
        // vm.deal(funder, fundAmount); // Funder get ETH to fund
        // // starts a session where subsequent actions are considered as being performed by the specified account
        // vm.startPrank(funder);
        // fundMe.fund{value: fundAmount}();
        // vm.stopPrank();
        // uint256 amountFunded = fundMe.getAddressToAmountFunded(funder);
    }

    /// @notice Test withdrawal of funds by owner.
    function testWithdrawalByOwner() public {
        address owner = fundMe.owner();

        // Arrange
        uint256 fundAmount = 1e18; // 1 ETH in Wei

        // 2 Ways to fund
        vm.deal(address(fundMe), fundAmount);
        // fundMe.fund{value: fundAmount}();
        uint256 beforeBalance = owner.balance;

        // Act
        // Owner is deploy contract, not test contract
        vm.startPrank(owner); // Start impersonating the owner
        fundMe.withdraw();
        vm.stopPrank(); // Stop impersonating the owner

        // Assert
        uint256 afterBalance = owner.balance;
        assertEq(
            afterBalance,
            beforeBalance + fundAmount,
            "Owner balance should have increased by fund amount"
        );
        assertEq(
            address(fundMe).balance,
            0,
            "Contract balance should be 0 after withdrawal"
        );
    }
}
