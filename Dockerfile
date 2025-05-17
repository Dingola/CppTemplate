# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set non-interactive mode for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Define environment variables
ENV BUILD_TYPE=Release
ENV BUILD_APP_PROJECT=true
ENV BUILD_TEST_PROJECT=true
ENV RUN_APP_ON_CONTAINER_START=false
ENV THIRD_PARTY_INCLUDE_DIR=/home/user/ThirdParty
ENV PROJECT_NAME=CppTemplate

# Install required system packages and CMake 3.28.0-rc3
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    locales \
    git \
    && wget https://github.com/Kitware/CMake/releases/download/v3.28.0-rc3/cmake-3.28.0-rc3-linux-x86_64.sh -O /tmp/cmake.sh \
    && chmod +x /tmp/cmake.sh \
    && /tmp/cmake.sh --skip-license --prefix=/usr/local || exit 1


# Configure UTF-8 locale
RUN locale-gen en_US.UTF-8 || exit 1
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create a working directory
WORKDIR /app

# Copy the source code into the container
COPY . .

# Create the ThirdParty directory
RUN mkdir -p ${THIRD_PARTY_INCLUDE_DIR} || exit 1

# Build the app project (if enabled)
RUN if [ "$BUILD_APP_PROJECT" = "true" ]; then \
    cmake -B _build_app_release -S . \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DTHIRD_PARTY_INCLUDE_DIR=${THIRD_PARTY_INCLUDE_DIR} \
        -DPROJECT_NAME=${PROJECT_NAME} \
        -DMAIN_PROJECT_NAME=${PROJECT_NAME} || exit 1; \
    cmake --build _build_app_release --config ${BUILD_TYPE} || exit 1; \
    fi

# Build the test project (if enabled)
RUN if [ "$BUILD_TEST_PROJECT" = "true" ]; then \
    cmake -B _build_tests_release -S . \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -D${PROJECT_NAME}_BUILD_TARGET_TYPE=static_library \
        -D${PROJECT_NAME}_BUILD_TEST_PROJECT=true \
        -DTHIRD_PARTY_INCLUDE_DIR=${THIRD_PARTY_INCLUDE_DIR} \
        -DPROJECT_NAME=${PROJECT_NAME} \
        -DMAIN_PROJECT_NAME=${PROJECT_NAME} || exit 1; \
    cmake --build _build_tests_release --config ${BUILD_TYPE} || exit 1; \
    fi

# Run tests (if enabled)
RUN if [ "$BUILD_TEST_PROJECT" = "true" ]; then \
    ./_build_tests_release/CPP_Project_Tests/${PROJECT_NAME}_Tests || exit 1; \
    fi

# Default command: Conditionally run the app executable
CMD if [ "$RUN_APP_ON_CONTAINER_START" = "true" ] && [ "$BUILD_APP_PROJECT" = "true" ]; then \
        ./_build_app_release/CPP_Project/${PROJECT_NAME}; \
    else \
        echo "No app project to run"; \
    fi
