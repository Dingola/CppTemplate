#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install Homebrew if not installed
install_homebrew() {
    if ! command_exists brew; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install CMake if not installed
install_cmake() {
    if ! command_exists cmake; then
        echo "CMake is not installed. Installing CMake..."
        brew install cmake
    else
        echo "CMake is already installed."
    fi
}

# Function to setup and build the project
setup_and_build() {
    local PROJECT_DIR=$1
    local PROJECT_NAME=$2
    local BUILD_TYPE=$3
    local BUILD_TARGET_TYPE=$4
    local BUILD_TEST_PROJECT=$5
    local THIRD_PARTY_INCLUDE_DIR=$6
    local BUILD_DIR_NAME=${7:-build}  # Default to "build" if not set

    # Install Homebrew and CMake
    install_homebrew
    install_cmake

    # Prepare
    mkdir -p "$THIRD_PARTY_INCLUDE_DIR"

    # Configure CMake
    BUILD_DIR="$(pwd)/$BUILD_DIR_NAME"
    cmake -S "$PROJECT_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -D${PROJECT_NAME}_BUILD_TARGET_TYPE:STRING=$BUILD_TARGET_TYPE -D${PROJECT_NAME}_BUILD_TEST_PROJECT:BOOL=$BUILD_TEST_PROJECT -DTHIRD_PARTY_INCLUDE_DIR:PATH=$THIRD_PARTY_INCLUDE_DIR

    # Build
    cmake --build "$BUILD_DIR" --config $BUILD_TYPE
}
