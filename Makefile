-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make [command]"
	@echo ""
	@echo "Available commands:"
	@echo "  deploy - Deploy the FundMe contract (requires 'network' arg, example: make deploy network=sepolia)"
	@echo "  fund - Fund the FundMe contract (requires 'network' and 'sender' args)"
	@echo "  withdraw - Withdraw from the FundMe contract (requires 'network' and 'sender' args)"
	@echo "  test - Run the test suite"
	@echo "  clean - Clean the build artifacts"
	@echo "  install - Install dependencies"
	@echo "  update - Update dependencies"
	@echo "  build - Compile the contracts"
	@echo "  format - Format the code"
	@echo "  anvil - Run a local testnet"

all: clean remove install update build

clean:
	forge clean

remove:
	rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "Removed modules"

install:
	forge install cyfrin/foundry-devops@0.0.11 --no-commit \
	&& forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit \
	&& forge install foundry-rs/forge-std@v1.5.3 --no-commit

update:
	forge update

build:
	forge build

test:
	forge test

snapshot:
	forge snapshot

format:
	forge fmt

anvil:
	anvil --port 8545 --chain-id 1337 --accounts 10

# Set network-specific args
network ?= localhost # Default network; override with make deploy network=sepolia
network_args := 
ifeq ($(network),sepolia)
    network_args := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

ifeq ($(network),localhost)
    network_args := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
endif

ifeq ($(network),polygon)
    network_args := --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(POLYGONSCAN_API_KEY) -vvvv
endif



# Deploy FundMe contract
deploy:
	@echo "Deploying to $(network) network..."
	forge script script/DeployFundMe.s.sol:DeployFundMe $(network_args)

# Ensure that if 'network' is not supported, we alert the user
ifneq ($(network), localhost)
ifneq ($(network), sepolia)
ifneq ($(network), polygon)
$(warning Unsupported network $(network). Supported networks are localhost, sepolia, and polygon.)
endif
endif
endif

# For deploying Interactions.s.sol:FundFundMe as well as for Interactions.s.sol:WithdrawFundMe we have to include a sender's address `--sender <ADDRESS>`
SENDER_ADDRESS := <sender's address>

fund:
	@forge script script/Interactions.s.sol:FundFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)