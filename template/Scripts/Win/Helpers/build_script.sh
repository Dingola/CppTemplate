#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -W)"

# Function to setup and build the project
setup_and_build() {
    local PROJECT_DIR=$1
    local PROJECT_NAME=$2
    local BUILD_TYPE=$3
    local BUILD_TARGET_TYPE=$4
    local BUILD_TEST_PROJECT=$5
    local THIRD_PARTY_INCLUDE_DIR=$6
    local BUILD_DIR_NAME=${7:-build}  # Default to "build" if not set

    # Prepare
    mkdir -p "$THIRD_PARTY_INCLUDE_DIR"
	
    # Configure CMake
    BUILD_DIR="$(pwd -W)/$BUILD_DIR_NAME"
    cmake -S "$PROJECT_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -D${PROJECT_NAME}_BUILD_TARGET_TYPE:STRING=$BUILD_TARGET_TYPE -D${PROJECT_NAME}_BUILD_TEST_PROJECT:BOOL=$BUILD_TEST_PROJECT -DTHIRD_PARTY_INCLUDE_DIR:PATH=$THIRD_PARTY_INCLUDE_DIR -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl

    # Build
    cmake --build "$BUILD_DIR" --config $BUILD_TYPE
}
