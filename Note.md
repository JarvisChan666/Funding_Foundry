## Refactor Deploy Script
The principles include considerations for gas optimizations, thorough auditing, key management, and verifying your source code

Best practice for deployment scripts involves minimizing state changes and contract deployments. In this context, the conditions that deploy mock contracts should be specifically triggered only when necessary, such as when on a local development network like Anvil.
Since the configurations for different networks are hardcoded and thus predictable, deploying mocks could be avoided in live networks altogether, which would save gas and reduce the deployment footprint.

## Explaination of msg.sender
Understanding the relationship between msg.sender, contract ownership, and the execution context in test environments requires dissecting how smart contracts interact during deployment and testing.

msg.sender Context:In Solidity, msg.sender refers to the address that is currently interacting with the contract. In the context of a contract calling another contract, msg.sender is the address of the caller contract.
Ownership and Deployment:When the FundMe contract is deployed, its constructor sets the owner variable to msg.sender. If you deploy the FundMe contract directly from an externally owned account (EOA), then msg.sender is that account. However, in your test environment, the FundMe contract is deployed by the DeployFundMe contract, which means, during that deployment process, the DeployFundMe contract is msg.sender.

Testing Context:In the FundMeTest contract, the setUp() function instantiates a new DeployFundMe contract and calls its run method to deploy a new FundMe contract. This implies that within the deployment process initiated by setUp, the DeployFundMe contract is msg.sender for the constructor of FundMe, and hence it becomes the owner.

However, when you call test1() or any similar function designed to assert the ownership in your test contract, the FundMeTest contract is the one interacting with the FundMe contract. At this point, the confusion arises because of how you might be impersonating or simulating transactions in your tests.