// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.19;
// 2. Imports

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundContract, WithdrawContract} from "../../script/Interactions.s.sol";

/// @title FundMe Integrations Tests
/// @notice This contract implements tests for the FundMe contract using the Forge framework for Solidity testing.
/// @author jarvischan

contract InteractionsTest is Test {
    FundMe private fundMe;
    HelperConfig public helperConfig;

    uint256 public constant SEND_VALUE = 0.1 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 private GAS_PRICE = 6;

    address public constant USER = address(1);

    /// @dev Sets up a new instance of the FundMe contract for each test case.
    /// Fundme i_owner is deploy script
    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, STARTING_USER_BALANCE);
        /*
        Within the deployment process(during that deployment process) initiated by setUp
        the DeployFundMe contract is msg.sender for the constructor of FundMe,
        and hence it becomes the i_owner.
        */
    }

    
    function testUserCanFundAndOwnerWithdraw() public {
        console.log("-------BEFORE FUNDING-------");
        uint256 preFundUserBalance = address(USER).balance;
        uint256 preFundOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 preFundFundMeBalance = address(fundMe).balance;
        console.log("preUserBalance: %s", preFundUserBalance);
        console.log("preOwnerBalance: %s", preFundOwnerBalance);
        console.log("preFundFundMeBalance: %s", preFundFundMeBalance);


        console.log("-------START FUNDING-------");
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        // FundContract fundFundMe = new FundContract();
        // fundFundMe.fundFundMe(address(fundMe));

        uint256 afterFundUserBalance = address(USER).balance;
        uint256 afterFundOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 afterFundFundMeBalance = address(fundMe).balance;
        console.log("afterFundUserBalance: %s", afterFundUserBalance);
        console.log("afterFundOwnerBalance: %s", afterFundOwnerBalance);
        console.log("afterFundFundMeBalance: %s", afterFundFundMeBalance);
        assertEq(afterFundUserBalance + SEND_VALUE, preFundUserBalance);
        assertEq(afterFundFundMeBalance, preFundFundMeBalance + SEND_VALUE);


        console.log("-------START WITHDRAWING-------");
        WithdrawContract withdrawFundMe = new WithdrawContract();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        uint256 afterWithdrawUserBalance = address(USER).balance;
        uint256 afterWithdrawOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 afterWithdrawFundMeBalance = address(fundMe).balance;
        console.log("afterWithdrawUserBalance: %s", afterWithdrawUserBalance);
        console.log("afterWithdrawOwnerBalance: %s", afterWithdrawOwnerBalance);
        console.log("afterWithdrawFundMeBalance: %s", afterWithdrawFundMeBalance);
        assert(afterWithdrawFundMeBalance == 0);
        assertEq(afterWithdrawOwnerBalance, preFundOwnerBalance + afterFundFundMeBalance);
        console.log("-------SHOW FUNDER-------");
        console.log("The actual Funder is the default address set by foundry:", address(msg.sender));
        console.log("The funder we think:", address(USER));
        
    
        // FundFundMe fundFundMe = new FundFundMe();
        // fundFundMe.fundFundMe(address(fundMe));
        // console.log("funder is: %s", fundMe.getFunder(0));
        // console.log("msg.sender is: %S", msg.sender);
        // console.log("default foundry sender balance: %S ", address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38).balance);
        
    }
}
