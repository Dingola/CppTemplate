#!/bin/bash

source Helpers/utils.sh
source Helpers/build_script.sh

# Set variables
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -W)"
PROJECT_NAME=$(basename "$PROJECT_DIR")
BUILD_TYPE="Release"
BUILD_TARGET_TYPE="static_library"
BUILD_TEST_PROJECT=true
THIRD_PARTY_INCLUDE_DIR="$(pwd -W)/ThirdPartyDir"
BUILD_DIR_NAME="_build_tests"

# Ensure the script is running as admin
check_admin

# Setup and build the project
setup_and_build $PROJECT_DIR $PROJECT_NAME $BUILD_TYPE $BUILD_TARGET_TYPE $BUILD_TEST_PROJECT $THIRD_PARTY_INCLUDE_DIR $BUILD_DIR_NAME

# Run tests
BUILD_DIR="$(pwd -W)/$BUILD_DIR_NAME"
if [ "$BUILD_TEST_PROJECT" = true ]; then
    "$BUILD_DIR/CPP_Project_Tests/${BUILD_TYPE}/${PROJECT_NAME}_Tests.exe"
fi

read -p "Press enter to continue"
