// SPDX-License-Identifier: MIT

/*
This contract allows users to fund it with ETH based on the USD value. 
It utilizes a Chainlink Price Feed to convert ETH amounts to USD equivalents.
*/

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

/// Custom error for easier identification and gas saving.
error FundMe_NotOwner();

/// @title A funding contract with minimum USD threshold
/// @dev This contract allows users to fund ETH and withdraw it by owner. It utilizes a Chainlink Price Feed for conversion rates.
/// @author jarvischan
contract FundMe {
    using PriceConverter for uint256;

    // State variables
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public immutable owner;
    uint256 public constant MINIMUM_USD = 5e18;
    bool private locked;
    AggregatorV3Interface private priceFeed;
    event FundReceived(address sender, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != owner) revert FundMe_NotOwner();
        _;
    }

    modifier nonReentrant() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    constructor(address priceFeedAddress) {
        // If we just deploy FundMe,
        // owner will be our own address
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    /// @notice Allows users to fund the contract with ETH based on the set USD value.
    /// @dev The amount of ETH is converted to USD using the current price feed value.
    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Insufficient ETH!"
        );
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    /// @notice Withdraws all funds from the contract sending them to the owner.
    /// @dev This function uses nonReentrancy modifier to prevent reentrant attacks.
    function withdraw() public onlyOwner nonReentrant {
        address[] memory fundersCopy = funders;
        for (uint256 i = 0; i < fundersCopy.length; i++) {
            address funder = fundersCopy[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool success, ) = payable(owner).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed");
    }

    /// @notice Returns the current price feed version.
    function getPriceFeedVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    // Fallback and receive functions to handle direct ETH transfers
    /*
    The difference is: 
    the Receive function is only called when the contract receives a transaction, 
    while the Fallback function, in addition to being called when the contract receives a transaction, is also called when there is no matching function in the contract or when additional data needs to be sent to the contract.
    */
    fallback() external payable {
        fund();
        emit FundReceived(msg.sender, msg.value);
    }

    receive() external payable {
        fund();
        emit FundReceived(msg.sender, msg.value);
    }

    // Optional getter for the size of the funders array.
    function getFunderCount() public view returns (uint256) {
        return funders.length;
    }
}
