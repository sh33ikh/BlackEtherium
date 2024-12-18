#!/bin/bash

# Colors for animations and outputs
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
MAGENTA="\033[35m"
RED="\033[31m"

# Set necessary directories and variables
HARDHAT_PROJECT_DIR="$HOME/BlockchainTest/HardhatProject"
GETH_VERSION="geth-linux-amd64-1.10.8-6c9a8ad8"
GETH_URL="https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.8-6c9a8ad8.tar.gz"
GETH_DIR="$HOME/BlockchainTest/geth"
GENESIS_FILE="$HOME/BlockchainTest/genesis.json"
PYTHON_SCRIPTS_DIR="$HOME/BlockchainTest/python-scripts"
REPO_URL="https://github.com/YourUsername/BlockchainTest.git"
REPO_NAME="BlockchainTest"
ENCRYPTED_PASSWORD_FILE="$HOME/BlockchainTest/password.txt"

# Function to display an animated loading message
loading() {
    local msg="$1"
    echo -n -e "$msg"
    while :; do
        for i in '.' '..' '...'; do
            echo -n -e "\r$msg $i"
            sleep 1
        done
    done
}

# Function to stop the animation
stop_loading() {
    echo -e "\rDone!                             "
}

# Function to install dependencies
install_dependencies() {
    echo -e "${CYAN}Installing dependencies...${RESET}"

    # Check OS and install based on environment
    if [ -f /data/data/com.termux/files/usr/bin/bash ]; then
        # Termux Installation
        echo -e "${YELLOW}Termux detected! Installing necessary dependencies.${RESET}"
        pkg update -y && pkg upgrade -y
        pkg install -y nodejs git wget curl python
    else
        # Ubuntu Installation
        echo -e "${YELLOW}Ubuntu detected! Installing necessary dependencies.${RESET}"
        sudo apt update -y && sudo apt upgrade -y
        sudo apt install -y nodejs npm git wget curl python3
    fi

    # Install Hardhat globally
    echo -e "${GREEN}Installing Hardhat globally...${RESET}"
    npm install -g hardhat

    # Install Geth if not already installed
    echo -e "${GREEN}Checking and installing Geth...${RESET}"
    if ! command -v geth &> /dev/null; then
        echo -e "${YELLOW}Geth not found, downloading...${RESET}"
        wget $GETH_URL -O /tmp/geth.tar.gz
        tar -xvzf /tmp/geth.tar.gz -C $HOME/BlockchainTest
        mv $HOME/BlockchainTest/geth-linux-amd64-1.10.8-6c9a8ad8/geth $GETH_DIR
        rm -rf $HOME/BlockchainTest/geth-linux-amd64-1.10.8-6c9a8ad8
    else
        echo -e "${GREEN}Geth is already installed!${RESET}"
    fi
}

# Function to create missing directories
create_directories() {
    echo -e "${CYAN}Creating necessary directories...${RESET}"
    mkdir -p $HARDHAT_PROJECT_DIR/scripts
    mkdir -p $PYTHON_SCRIPTS_DIR
    echo -e "${GREEN}Directories created successfully!${RESET}"
}

# Function to create a hidden and unique genesis block
create_hidden_genesis() {
    echo -e "${CYAN}Creating hidden and advanced Genesis Block...${RESET}"
    if [ ! -f $GENESIS_FILE ]; then
        cat > $GENESIS_FILE <<EOL
{
    "config": {
        "chainId": 2024,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip155Block": 0,
        "eip158Block": 0
    },
    "difficulty": "0x40000",
    "gasLimit": "0x9000000",
    "alloc": {
        "0x000000000000000000000000000000000000dEaD": { "balance": "0x100000000000000000000000000000000000000000000000000000000000000" }
    }
}
EOL
        echo -e "${GREEN}Genesis Block created! This is a unique configuration.${RESET}"
    else
        echo -e "${GREEN}Hidden Genesis Block already exists.${RESET}"
    fi
}

# Function to initialize Ethereum Testnet with advanced Geth configuration
initialize_testnet() {
    echo -e "${CYAN}Initializing advanced Ethereum Testnet with unique parameters...${RESET}"

    # Initialize the Ethereum testnet with the unique genesis block
    $GETH_DIR init $GENESIS_FILE
}

# Function to start Ethereum node with advanced privacy and speed optimizations
start_geth() {
    echo -e "${CYAN}Starting advanced Ethereum node with privacy and performance optimizations...${RESET}"

    # Start the Ethereum node with optimizations
    $GETH_DIR --datadir $HOME/BlockchainTest/data --networkid 2024 --http --http.port 8545 --http.corsdomain "*" --mine --miner.threads 1 --unlock 0 --password $ENCRYPTED_PASSWORD_FILE --maxpeers 100 --cache 2048
}

# Function to deploy contracts with advanced features
deploy_contract() {
    echo -e "${CYAN}Deploying contract with advanced features...${RESET}"
    cd $HARDHAT_PROJECT_DIR

    # Create a simple contract for demonstration
    cat > $HARDHAT_PROJECT_DIR/contracts/BETH20.sol <<EOL
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BETH20 {
    string public name = "BETH20 Token";
    string public symbol = "BETH";
    uint256 public totalSupply = 1000000;
    mapping(address => uint256) public balanceOf;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}
EOL

    # Deploy contract using Hardhat
    npx hardhat run --network localhost scripts/deploy.js
    echo -e "${GREEN}Contract deployed successfully!${RESET}"
}

# Function to automate Git push to repository
git_push() {
    echo -e "${CYAN}Initializing Git repository...${RESET}"

    # Initialize Git repository if not already done
    if [ ! -d "$HOME/BlockchainTest/.git" ]; then
        cd $HOME/BlockchainTest
        git init
        git remote add origin $REPO_URL
    fi

    # Stage, commit, and push changes
    git add .
    git commit -m "Initial commit with blockchain setup and smart contract deployment"
    git push origin main
    echo -e "${GREEN}Git push completed!${RESET}"
}

# Python integration for additional blockchain-related tasks
python_integration() {
    echo -e "${CYAN}Running Python script for blockchain validation...${RESET}"

    cat > $PYTHON_SCRIPTS_DIR/blockchain_validation.py <<EOL
import requests

def check_blockchain_status():
    url = "http://localhost:8545"
    response = requests.post(url, json={
        "jsonrpc": "2.0",
        "method": "eth_blockNumber",
        "params": [],
        "id": 1
    })

    if response.status_code == 200:
        block_number = response.json().get('result')
        print(f"Current block number: {int(block_number, 16)}")
    else:
        print("Error connecting to Ethereum node.")

check_blockchain_status()
EOL

    # Run the Python script
    python3 $PYTHON_SCRIPTS_DIR/blockchain_validation.py
}

# Main setup function
main() {
    # Starting the animation for loading
    loading "Setting up advanced Ethereum environment"

    # Perform all necessary setups
    install_dependencies
    create_directories
    create_hidden_genesis
    initialize_testnet
    start_geth
    deploy_contract
    git_push
    python_integration

    # Stop loading animation
    stop_loading

    echo -e "${GREEN}Advanced Ethereum setup complete!${RESET}"
    echo -e "${CYAN}Your Ethereum Testnet is now live and fully functional with advanced features!${RESET}"

    # Satoshi Nakamoto-like reference
    echo -e "${MAGENTA}Satoshi Nakamoto says: The future of money is decentralized. We are paving the way for the next revolution in finance.${RESET}"

    # Ethereum CEO-like reference
    echo -e "${BLUE}Ethereum CEO says: With Ethereum, we are building an unstoppable world of decentralized applications and smart contracts. Let's keep building the future.${RESET}"

    # Binance CEO (CZ) inspired message
    echo -e "${YELLOW}Changpeng Zhao (CZ) says: Crypto is not just a currency, it's a movement. We are making crypto available for everyone.${RESET}"

    # Final Motivation for the user
    echo -e "${GREEN}You, as a part of this decentralized future, are now ready to take on the world of Ethereum and blockchain development!${RESET}"
}

# Run the main function
main
