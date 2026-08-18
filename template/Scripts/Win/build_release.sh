#!/bin/bash

source Helpers/utils.sh
source Helpers/build_script.sh

# Set variables
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -W)"
PROJECT_NAME=$(basename "$PROJECT_DIR")
BUILD_TYPE="Release"
BUILD_TARGET_TYPE="executable"
BUILD_TEST_PROJECT=false
THIRD_PARTY_INCLUDE_DIR="$(pwd -W)/ThirdPartyDir"
BUILD_DIR_NAME="_build_release"

# Ensure the script is running as admin
check_admin

# Setup and build the project
setup_and_build $PROJECT_DIR $PROJECT_NAME $BUILD_TYPE $BUILD_TARGET_TYPE $BUILD_TEST_PROJECT $THIRD_PARTY_INCLUDE_DIR $BUILD_DIR_NAME

# Ask the user if they want to run the built project
read -p "Do you want to run the built project? (y/n): " run_choice
BUILD_DIR="$(pwd -W)/$BUILD_DIR_NAME"
if [[ "$run_choice" =~ ^[yY]$ ]]; then
    "$BUILD_DIR/CPP_Project/${BUILD_TYPE}/${PROJECT_NAME}.exe"
fi

read -p "Press enter to continue"
