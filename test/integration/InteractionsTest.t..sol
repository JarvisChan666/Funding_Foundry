// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.19;
// 2. Imports

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {WithdrawContract} from "../../script/Interactions.s.sol";

/// @title FundMe Integrations Tests
/// @notice This contract implements tests for the FundMe contract using the Forge framework for Solidity testing.
/// @author jarvischan

contract InteractionsTest is Test {
    FundMe private fundMe;
    DeployFundMe private deployFundMe;
    address private FUNDER = makeAddr("jarvis");
    uint256 private fundAmount = 2e18;
    uint256 private GAS_PRICE = 6;

    /// @dev Sets up a new instance of the FundMe contract for each test case.
    /// Fundme i_owner is deploy script
    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        /*
        Within the deployment process(during that deployment process) initiated by setUp
        the DeployFundMe contract is msg.sender for the constructor of FundMe,
        and hence it becomes the i_owner.
        */
    }

    
    function testUserCanFundInteractions() public {
        // Arrange

        // Ensure FUNDER has enough funds to send
        vm.deal(FUNDER, fundAmount);

        uint256 preFundBalance = address(fundMe).balance;
        uint256 preFundFunderBalance = address(FUNDER).balance;
        uint256 preFundOwnerBalance = fundMe.i_owner().balance;
        console.log(
            "FundMe contract balance before funding: %s",
            preFundBalance
        );
        console.log("Funder balance before funding: %s", preFundFunderBalance);
        console.log("Owner balance before funding: %s", preFundOwnerBalance);
        console.log(
            "----------------------------------------------------------"
        );
        
        // Act

        // Fund
        console.log("Funding from the FUNDER...");
        vm.prank(FUNDER); // FUNDER will be the msg.sender for the next transaction only.
        fundMe.fund{value: fundAmount}(); // Directly call the fund function send value

        uint256 afterFundBalance = address(fundMe).balance;
        uint256 afterFundFunderBalance = address(FUNDER).balance;
        console.log(
            "FundMe contract balance after funding: %s",
            afterFundBalance
        );
        console.log("Funder balance after funding: %s", afterFundFunderBalance);
        console.log(
            "----------------------------------------------------------"
        );

        // Withdraw
        WithdrawContract withdrawFundMe = new WithdrawContract();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        uint256 afterWithdrawBalance = address(fundMe).balance;
        uint256 afterWithdrawOwnerBalance = fundMe.i_owner().balance;
        console.log(
            "FundMe contract balance after withdrawing: %s",
            afterWithdrawBalance
        );
        console.log(
            "Owner balance after withdrawinging: %s",
            afterWithdrawOwnerBalance
        );

        // Assert

        assert(address(fundMe).balance == 0);
        assertEq(afterWithdrawOwnerBalance, preFundFunderBalance + preFundOwnerBalance);
    }
    // function testUserCanWithdrawFunds() public {
    //     // Arrange
    //     vm.deal(FUNDER, fundAmount);
    //     uint256 preFundBalance = address(fundMe).balance;
    //     uint256 preFundFunderBalance = address(FUNDER).balance;
    //     uint256 preFundOwnerBalance = fundMe.i_owner().balance;
    //     console.log(
    //         "FundMe contract balance before funding: %s",
    //         preFundBalance
    //     );
    //     console.log("Funder balance before funding: %s", preFundFunderBalance);
    //     console.log("Owner balance before funding: %s", preFundOwnerBalance);

    //     // Act
    //     // Fund
    //     vm.deal(FUNDER, fundAmount); // Make sure FUNDER has enough ETH.
    //     vm.prank(FUNDER);
    //     fundMe.fund{value: fundAmount}();

    //     uint256 afterFundBalance = address(fundMe).balance;
    //     uint256 afterFundFunderBalance = address(FUNDER).balance;
    //     console.log(
    //         "FundMe contract balance after funding: %s",
    //         afterFundBalance
    //     );
    //     console.log("Funder balance after funding: %s", afterFundFunderBalance);

    //     // Withdraw
    //     vm.prank(fundMe.i_owner());
    //     fundMe.withdraw();
    //     uint256 afterWithdrawBalance = address(fundMe).balance;
    //     uint256 afterWithdrawOwnerBalance = fundMe.i_owner().balance;
    //     console.log(
    //         "FundMe contract balance after withdrawing: %s",
    //         afterWithdrawBalance
    //     );
    //     console.log(
    //         "Owner balance after withdrawinging: %s",
    //         afterWithdrawOwnerBalance
    //     );
    //     // Assert
    //     assertEq(
    //         address(fundMe).balance,
    //         0,
    //         "FundMe should have 0 balance after withdrawal"
    //     );
    //     assertEq(
    //         afterFundBalance,
    //         preFundBalance + fundAmount,
    //         "FundMe should receive fundAmount eth"
    //     );
    //     assertEq(
    //         preFundOwnerBalance + fundAmount,
    //         afterWithdrawOwnerBalance,
    //         "Withdrawer should receive funds"
    //     );
    // }
}
