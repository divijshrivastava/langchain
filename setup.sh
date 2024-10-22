#!/bin/bash


# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if ollama is installed
check_ollama_installed() {
    if ! command -v ollama &> /dev/null; then
        echo -e "${RED}Ollama is not installed!${NC}"
        echo "Installing Ollama..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install ollama
        else
            echo -e "${RED}Please install Ollama manually from https://ollama.ai/download${NC}"
            exit 1
        fi
    fi
}

# Function to check if ollama service is running
check_ollama_service() {
    if ! curl -s http://localhost:11434/api/tags &> /dev/null; then
        echo -e "${YELLOW}Ollama service is not running.${NC}"
        echo "Starting Ollama service..."
        ollama serve &
        sleep 5  # Wait for service to start
        
        # Check again
        if ! curl -s http://localhost:11434/api/tags &> /dev/null; then
            echo -e "${RED}Failed to start Ollama service!${NC}"
            exit 1
        fi
        echo -e "${GREEN}Ollama service started successfully.${NC}"
    else
        echo -e "${GREEN}Ollama service is running.${NC}"
    fi
}

# Function to check if llama2 is installed
check_llama2_installed() {
    if ollama list | grep -q "llama2"; then
        echo -e "${GREEN}Llama2 is already installed.${NC}"
        return 0
    else
        echo -e "${YELLOW}Llama2 is not installed.${NC}"
        return 1
    fi
}

# Function to pull llama2
pull_llama2() {
    echo "Pulling Llama2 model..."
    if ollama pull llama2; then
        echo -e "${GREEN}Llama2 installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}Failed to install Llama2!${NC}"
        return 1
    fi
}

# Function to test llama2
test_llama2() {
    echo "Testing Llama2..."
    if response=$(ollama run llama2 "Hi, give me a one-word response." 2>&1); then
        echo -e "${GREEN}Test successful! Response:${NC}"
        echo "$response"
        return 0
    else
        echo -e "${RED}Test failed! Error:${NC}"
        echo "$response"
        return 1
    fi
}

environment_setup() {
    echo "Setting up environment..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install python3
    else
        sudo apt-get update
        sudo apt-get install python3 .venv
    fi
}

# Settingup environment
environment_setup
# Main script
echo "Setting up Llama2..."

# Check if ollama is installed
check_ollama_installed

# Check if ollama service is running
check_ollama_service

# Check if llama2 is installed
if ! check_llama2_installed; then
    # Pull llama2 if not installed
    pull_llama2 || exit 1
fi

# Test llama2
test_llama2

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

clear
echo "Starting chat with your personal AI assistant!"
python3 chat.py
