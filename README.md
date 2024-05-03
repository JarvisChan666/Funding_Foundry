# FundMe Solidity Contract

## Overview
The FundMe contract provides a platform for users to fund with Ether (ETH) based on the USD value. It leverages Chainlink Price Feeds to ensure accurate ETH to USD conversions, making it a reliable and transparent way to manage blockchain funding efforts.

## Requirements
- git
- foundry
- solidity
- metamask wallet

The FundMe contract is written in Solidity ^0.8.18 and designed for the Ethereum blockchain. To interact with the contract, users must have an Ethereum wallet with ETH and be connected to a network that has access to Chainlink Data Feeds.

## QuickStart
1. **Initialization**
   
```
git clone https://github.com/JarvisChan666/Funding_Foundry
cd Funding_Foundry
npm install / yarn
make build
```
2. Run **Anvil local network** and deploy FundMe contract
- **In the first terminal**:**
```
make anvil
```
- **In the second terminal**:
```

make deploy
```
3. Update your `constants.js` with your deployed FundMe contract address(In the second terminal)
```solidity
export const contractAddress = "${your address}"
```
4. Right click the "**index.html**" in your VSCode and run **"open with live server"**(Please install "Live Server" plugin on your vscode first!).
5. Add the local network in MetaMask
   1. id:31337
   2. RPC-URL:127.0.0.1:8545
6. Now you can interact with FundMe contract by using this "BEAUTIFUL" UI !



## Usage

### Deploy:
```
forge script script/DeployFundMe.s.sol
```
### Testing
We talk about 4 test tiers in the video.

1. Unit
2. Integration
3. Forked
4. Staging
This repo we cover #1 and #3.
```
forge test
```
or
```
// Only run test functions matching the specified regex pattern.

"forge test -m testFunctionName" is deprecated. Please use 

forge test --match-test testFunctionName
```

or
```
forge test --fork-url $SEPOLIA_RPC_URL
Test Coverage
forge coverage
```

## Deployment to a testnet or mainnet
**1. Setup environment variables**
You'll want to set your SEPOLIA_RPC_URL and PRIVATE_KEY as environment variables. You can add them to a .env file, similar to what you see in .env.example.

- PRIVATE_KEY: The private key of your account (like from metamask). NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
You can learn how to export it here.
- SEPOLIA_RPC_URL: This is url of the sepolia testnet node you're working with. You can get setup with one for free from Alchemy
Optionally, add your ETHERSCAN_API_KEY if you want to verify your contract on Etherscan.

**2. Get testnet ETH**
Head over to faucets.chain.link and get some testnet ETH. You should see the ETH show up in your metamask.

**3. Deploy**
```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```
**Scripts**
After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:
```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```
or
```
forge script script/Interactions.s.sol --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```
**Withdraw**
```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```

**Estimate gas**
You can estimate how much gas things cost by running:
```
forge snapshot
```
And you'll see an output file called .gas-snapshot

**Formatting**
To run code formatting:
```
forge fmt
```

## How to git comment
feat(tests): add comprehensive FundMe tests

- Implement testFundAndBalanceUpdate to verify contract balance increases correctly after funding.
- Develop testFunderIsAddedToList to ensure funders array is updated accurately post-funding.
- Establish testWithdrawalByOwner to check only owner can withdraw and their balance updates.

These tests aim to improve the reliability and coverage of FundMe contract functionality.

---
**Thank you!**
If you appreciated this, feel free to follow me or donate!

ETH/Arbitrum/Optimism/Polygon/etc Address:
**0x68D2067c4C82aa99490F5B4Be411CeB71A615622**
