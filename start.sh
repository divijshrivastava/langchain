#!/bin/bash

# Function to check if Python3 is installed
check_python_installed() {
    if ! command -v python3 &> /dev/null; then
        echo "Python3 is not installed. Installing..."
        apt-get update && apt-get install -y python3
    else
        echo "Python3 is already installed."
    fi
}

# Function to set up the Python environment
setup_python_environment() {
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        echo "Virtual environment created."
    else
        echo "Virtual environment already exists."
    fi
    source .venv/bin/activate
    pip install -r requirements.txt
}

# Main script
echo "Setting up Llama2..."

# Check if Python3 is installed
check_python_installed

# Set up the Python environment
setup_python_environment

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