#!/bin/bash

source Helpers/build_script.sh

# Set variables
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT_NAME=$(basename "$PROJECT_DIR")
BUILD_TYPE="Release"
BUILD_TARGET_TYPE="static_library"
BUILD_TEST_PROJECT=true
THIRD_PARTY_INCLUDE_DIR="$(pwd)/ThirdPartyDir"
BUILD_DIR_NAME="_build_tests"

# Setup and build the project
setup_and_build $PROJECT_DIR $PROJECT_NAME $BUILD_TYPE $BUILD_TARGET_TYPE $BUILD_TEST_PROJECT $THIRD_PARTY_INCLUDE_DIR $BUILD_DIR_NAME

# Run tests
BUILD_DIR="$(pwd)/$BUILD_DIR_NAME"
if [ "$BUILD_TEST_PROJECT" = true ]; then
    "$BUILD_DIR/CPP_Project_Tests/${PROJECT_NAME}_Tests"
fi

read -p "Press enter to continue"
