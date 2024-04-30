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
    FundMe private fundMe;
    DeployFundMe private deployFundMe;
    address private FUNDER = makeAddr("jarvis");
    uint256 private fundAmount = 1e18;
    uint256 private GAS_PRICE = 6;

    /// @dev Sets up a new instance of the FundMe contract for each test case.
    /// Fundme owner is deploy script
    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        /*
        Within the deployment process(during that deployment process) initiated by setUp
        the DeployFundMe contract is msg.sender for the constructor of FundMe,
        and hence it becomes the owner.
        */
    }

    modifier funded() {
        vm.prank(FUNDER);
        vm.deal(FUNDER, fundAmount);
        fundMe.fund{value: fundAmount}();
        _;
    }

    /// @notice Testing that the minimum USD funding amount is set correctly in the FundMe contract.
    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    /// @notice
    function testOwnerIsMsgSender() public view {
        console.log(fundMe.owner()); //0x18
        assertEq(fundMe.owner(), msg.sender);
    }

    /// @notice Test funding of the contract and balance update.
    /// Only pass in local mock
    function testFundAndBalanceUpdate() public {
        uint256 beforeBalance = address(fundMe).balance;
        vm.deal(FUNDER, fundAmount);
        vm.startPrank(FUNDER);
        fundMe.fund{value: fundAmount}();
        vm.stopPrank();

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
        vm.deal(FUNDER, fundAmount); // Funder get ETH to fund
        // starts a session where subsequent actions are considered as being performed by the specified account
        vm.startPrank(FUNDER);
        fundMe.fund{value: fundAmount}();
        vm.stopPrank();

        // check if the last FUNDER in the array is the address that just funded
        address lastFunder = fundMe.funders(fundMe.getFunderCount() - 1);
        assertEq(lastFunder, FUNDER, "Funder should be added to funders list");
    }

    function testAddressToAmountFunded() public {
        vm.deal(FUNDER, fundAmount); // Funder get ETH to fund
        // starts a session where subsequent actions are considered as being performed by the specified account
        vm.startPrank(FUNDER);
        fundMe.fund{value: fundAmount}();
        vm.stopPrank();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(FUNDER);

        // Another way to test, using test contract itself
        // fundMe.fund{value: fundAmount}();
        // uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));

        assertEq(fundAmount, amountFunded);
    }

    /// @notice Test withdrawal of funds by owner.
    /// check balance, check if not withdrawed by owner
    function testWithdrawNotByOwner() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawBySingleOwner() public funded {
        // Arrange
        uint256 beforeOwnerBalance = fundMe.owner().balance;
        uint256 beforeFundMeBalance = address(fundMe).balance;

        //Act
        uint256 beforeGas  = gasleft(); // How much gas you left before transaction.
        vm.txGasPrice(GAS_PRICE); // et the 
        vm.prank(fundMe.owner());
        fundMe.withdraw();

        uint256 afterGas  = gasleft();
        uint256 gasUsed = (beforeGas - afterGas) * tx.gasprice; 
        console.log(gasUsed);
        console.log(tx.gasprice);
        console.log(beforeGas);
        console.log(afterGas);

        // Assert
        uint256 afterOwnerBalance = fundMe.owner().balance;
        uint256 afterFundMeBalance = address(fundMe).balance;
        // Assert
        assertEq(afterFundMeBalance, 0);
        assertEq(afterOwnerBalance, beforeOwnerBalance + beforeFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders =  10;
        uint160 index = 1;
        for (uint160 i = index; i < numberOfFunders; i++) {
            // hoax = prank + deal
            hoax(address(i), fundAmount);
            fundMe.fund{value: fundAmount}();
        }

        uint256 beforeOwnerBalance =fundMe.owner().balance;
        uint256 beforeFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.owner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 afterFundMeBalance = address(fundMe).balance;
        uint256 afterOwnerBalance = fundMe.owner().balance;

        // Assert
        assertEq(afterFundMeBalance, 0);
        assertEq(beforeFundMeBalance + beforeOwnerBalance, afterOwnerBalance);
    }
}
