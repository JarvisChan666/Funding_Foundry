// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

// contract FundContract is Script {
//     uint256 constant SEND_VALUE = 0.01 ether;

//     function fundFundMe(address mostRecentDeployed) public {
//         vm.startBroadcast();
//         FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
//         vm.stopBroadcast();
//         console.log("Funded FundMe with %s", SEND_VALUE);
//     }

//     function run() external {
//         address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
//             "FundMe",
//             block.chainid
//         );
//         vm.startBroadcast();
//         fundFundMe(mostRecentDeployed);
//         vm.stopBroadcast();
//     }
// }

contract WithdrawContract is Script {
    function withdrawFundMe(address mostRecentDeployed) public {
        // Broadcasti can set the script up to make real (simulated or on-chain) transactions
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawed FundMe");
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}


// An abstract contract that provides basic interaction functionality.
// abstract contract InteractionBase is Script {
//     // Internal function to handle a generic transaction to any contract.
//     // The `target` is the contract address you are calling, and `data` is the transaction data.
//     function handleTransaction(address target, bytes memory data) internal {
//         // Start listening for transaction to potentially broadcast.
//         vm.startBroadcast();
//         // A low-level call to send the transaction to the `target` contract with `data`.
//         // Returns a boolean to indicate success or failure.
//         (bool success, ) = target.call{value: msg.value}(data);
//         require(success, "Transaction failed");
//         // Stops broadcasting further transactions.
//         vm.stopBroadcast();
//     }

//     // A public function that can be called to interact with a contract.
//     // It logs the interaction and then sends the transaction.
//     function performInteraction(
//         address contractAddress,
//         bytes memory data
//     ) public {
//         console.log("Interacting with contract...");
//         handleTransaction(contractAddress, data);
//     }
// }

// A concrete contract that inherits `InteractionBase` and implements fund functionality.
// contract FundContract is InteractionBase {
//     // A constant value that defines how much ETH will be sent with the funding transaction.
//     uint256 constant SEND_VALUE = 0.01 ether;

//     // Public function that triggers the funding.
//     // `contractAddress` is the address of the `FundMe` contract that you want to fund.
//     function fundContract(address contractAddress) public payable{
//         // Calls `performInteraction` with the proper data, which will call the `fund` function on the `FundMe` contract
//         performInteraction(
//             contractAddress,
//             // ABI encoding is used to encode the selector for the fund function call.
//             // The selector is a unique identifier for the fund function in the contract.
//             abi.encodeWithSelector(FundMe.fund.selector)
//         );
//         console.log("Funded FundMe with", SEND_VALUE);
//     }
// }

// Similar structure for `WithdrawContract` can be defined using the above pattern.
// Additional contracts `FundContract` and `WithdrawContract` are kept for the sake of the example provided by the user
// and contain similar functionality as demonstrated above.

// contract WithdrawContract is InteractionBase {
//     function withdrawContract(address contractAddress) public {
//         performInteraction(
//             contractAddress,
//             abi.encodeWithSelector(FundMe.withdraw.selector)
//         );
//         console.log("Withdrawn from FundMe");
//     }
// }

