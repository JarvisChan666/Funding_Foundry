forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

forge test -m xxx -vvv --fork-url

forge test --fork-url $MAINNET_RPC_URL

## How to git comment
feat(tests): add comprehensive FundMe tests

- Implement testFundAndBalanceUpdate to verify contract balance increases correctly after funding.
- Develop testFunderIsAddedToList to ensure funders array is updated accurately post-funding.
- Establish testWithdrawalByOwner to check only owner can withdraw and their balance updates.

These tests aim to improve the reliability and coverage of FundMe contract functionality.