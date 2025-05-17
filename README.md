# Cpp Template

## 🚀 [Build Status]

### 🛠 Build and ✅ Test

[![Linux Build and Test](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_linux.yml/badge.svg)](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_linux.yml)
[![macOS Build and Test](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_macos.yml/badge.svg)](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_macos.yml)
[![Windows Build and Test](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_windows.yml/badge.svg)](https://github.com/Dingola/CppTemplate/actions/workflows/build_and_test_windows.yml)

### Code Coverage

[![codecov](https://codecov.io/gh/Dingola/CppTemplate/graph/badge.svg?token=IUM73S6W22)](https://codecov.io/gh/Dingola/CppTemplate)

<br><br>

## 🔐 Tokens for GitHub Actions

Some workflows in this repository require tokens to function correctly. Below are the details for the required tokens and how to configure them.

### 1. Codecov Token (Required for Code Coverage)

The **CODECOV_TOKEN** is required to upload code coverage reports to [Codecov](https://codecov.io). This token ensures that only authorized users can upload coverage data for your repository.

#### How to create the Codecov Token:

1. Go to your repository on [Codecov](https://codecov.io).
2. Navigate to **Settings → Repository → Upload Token**.
3. Copy the generated token.

### 2. Personal Access Token (PAT) [Optional]

The **Personal Access Token (PAT)** is only required for the disabled workflows in this repository. These workflows are kept for reference and are not actively used in the CI/CD pipeline.

#### How to create the PAT:

1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
2. Click **“Generate new token (classic)”**.
3. Set a name (e.g., `Legacy CI Token`) and expiration date.
4. Under **Scopes**, check:
   - `repo`
5. Click **“Generate token”** and copy the token immediately.

### Adding Tokens as Repository Secrets

Once you have generated the required tokens, add them as secrets in your GitHub repository:

1. Open your repository on GitHub.
2. Navigate to:
   **Settings → Secrets and variables → Actions → New repository secret**
3. Add the following secrets:
   - **For Codecov**:
     - **Name**: `CODECOV_TOKEN`
     - **Secret**: *(paste the Codecov token)*
   - **For Disabled Workflows**:
     - **Name**: `PAT_TOKEN`
     - **Secret**: *(paste the PAT token)*

> **Note**: The `CODECOV_TOKEN` is required for the `build_and_test_linux.yml` workflow to upload coverage reports. The `PAT_TOKEN` is only needed for the disabled workflows.

<br><br>

## 📖 [Table of Contents]
- [Code Coverage Graphs](#-code-coverage-graphs)
- [Description](#description)
- [Solution Folder Structure](#solution-folder-structure)
- [Configuration](#configuration)
  - [CMake Options](#cmake-options)
  - [Environment Variables](#environment-variables)
- [Supported Platforms](#supported-platforms)
- [How to Install and Run](#how-to-install-and-run)
  - [1) Prerequisites](#1-prerequisites)
  - [2) Setting up](#2-setting-up)
  - [3) Configuring and Building](#3-configuring-and-building)
  - [4) Run the project](#4-run-the-project)
  - [5) Deployment](#5-deployment)
  - [6) Using Docker](#6-using-docker)
- [Code Style and Linting](#code-style-and-linting)

<br><br>

## 📊 [Code Coverage Graphs]

| Graph     | Description                                                                                                                                                                                                                     | Visualization                                                                 |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| **Sunburst** | The inner-most circle represents the entire project. Moving outward are folders, and finally individual files. The size and color of each slice represent the number of statements and the coverage, respectively. | <img src="https://codecov.io/gh/Dingola/CppTemplate/graphs/sunburst.svg?token=IUM73S6W22" alt="Sunburst" height="100" width="200"> |
| **Grid**     | Each block represents a single file in the project. The size and color of each block represent the number of statements and the coverage, respectively.                                                                      | <img src="https://codecov.io/gh/Dingola/CppTemplate/graphs/tree.svg?token=IUM73S6W22" alt="Grid" height="100" width="200">         |
| **Icicle**   | The top section represents the entire project, followed by folders and individual files. The size and color of each slice represent the number of statements and the coverage, respectively.                                 | <img src="https://codecov.io/gh/Dingola/CppTemplate/graphs/icicle.svg?token=IUM73S6W22" alt="Icicle" height="150" width="400">     |

<br><br>


## [Description]
This project is a template for creating C++-based applications. The solution is divided into two parts: the main project and a test project. 
By default, only the main project is built. The test project can be built if desired, controlled by a CMake boolean variable `<PROJECT_NAME>_BUILD_TEST_PROJECT`. 
Additionally, the CMake variable `<PROJECT_NAME>_BUILD_TARGET_TYPE` must be set to `static_library` for the test project to be executed.

The template allows for the generation of project documentation using Doxygen. It also includes GitHub workflows (CI builds) for Linux, macOS, and Windows.
<br><br>

## [Solution Folder Structure]

```
.
├── .git                    # Git repository metadata
├── .github                 # GitHub-specific files (CI workflows)
├── CMake                   # CMake files used in both the project and tests
├── Configs                 # Configuration files for clang-tidy, clang-format, Doxygen, etc.
├── CPP_Project             # The main project
│   ├── CMake               # CMake files specific to the project
│   ├── Headers             # Header files
│   ├── Resources           # Resource files
│   ├── Sources             # Source files
│   ├── ThirdParty          # CMake files for external dependencies
│   ├── CMakeLists.txt      # CMake configuration file for the project
│   ├── Config.h.in         # Configuration header template
│   └── main.cpp            # Main application entry point
├── CPP_Project_Tests       # Tests for the project
│   ├── Headers             # Header files for tests
│   ├── Sources             # Source files for tests
│   ├── ThirdParty          # CMake files for external dependencies used in tests
│   ├── CMakeLists.txt      # CMake configuration file for tests
│   └── main.cpp            # Main entry point for tests
├── Scripts                 # Scripts for building and deploying on various platforms
│   ├── Win                 # Windows-specific scripts
│   ├── Linux               # Linux-specific scripts
│   └── Mac                 # Mac-specific scripts
├── Dockerfile              # Dockerfile for building and running the project in a container
├── .gitignore              # Git ignore file
├── CMakeLists.txt          # Top-level CMake configuration file
└── README.md               # Project README file
```
<br><br><br>

## [Configuration]

### CMake-Options
* **<PROJECT_NAME>_BUILD_TARGET_TYPE:** Specifies the type of build for the application. Possible values are:
  - `executable`
  - `dynamic_library`
  - `static_library`

* **<PROJECT_NAME>_BUILD_TEST_PROJECT:** Specifies whether the **TestProject** should also be built. Default is **Off**.

* **USE_CLANG_FORMAT:** Specifies whether `clang-format` should be used for code formatting. Default is **Off**.

* **USE_CLANG_TIDY:** Specifies whether `clang-tidy` should be used for static analysis. Default is **Off**.

* **CLANG_TOOLS_PATH:** Specifies the path to the `clang-format` and `clang-tidy` executables.

* **<PROJECT_NAME>_BUILD_DOC:** Specifies whether **documentation** should be generated for the app and/or its test project. The generated documentation is located in the `doc` folder within the binary directory, with separate subfolders for the app and the test project. The formatting specifications for the documentation can be centrally configured in the Doxyfile.in file, located in the solution folder. The default setting is **Off**.

* **THIRD_PARTY_INCLUDE_DIR:** Specifies where the third-party libraries will be installed. The default path is:
  - **`$USERPROFILE/ThirdParty`** on Windows
  - **`$HOME/ThirdParty`** on Unix-based systems.

* **SANITIZER_TYPE:** Specifies the type of sanitizer to use for the build process. Supported values are:
  - `none`
  - `address`
  - `leak`
  - `memory`
  - `thread`
  - `address_and_leak`
  - `address_and_memory`
  - `memory_and_leak`
  - `address_memory_and_leak`
> [!NOTE]
> **Platform-specific notes:**
>  - MSVC supports: `none`, `address`
>  - UNIX supports: all of the above
<br>

---
<br>

### Environment Variables
* _No environment variables are required for this template at the moment._
<br><br><br>

## [Supported Platforms]
- Windows 10+
- Linux (tested on Ubuntu 24.04.1)
- Mac (tested on macOS Ventura)
<br><br><br>

## [How To Install and Run]

### 1) Prerequisites
* CMake ( Minimum required version 3.19.0 ): [Download](https://cmake.org/download/ "CMake Downloads")
* A C++20 compatible compiler (e.g., GCC 10+, Clang 10+, MSVC 19.28+)
* Optional: Docker (if using the Docker workflow in [6) Using Docker](#6-using-docker)): [Download Docker](https://www.docker.com/)
* Optional: Doxygen (if documentation generation is enabled): [Download](https://www.doxygen.nl/download.html)
* Optional for Doxygen is LaTeX if enabled in `Doxygen.in`-File and installed.
* Optional: `zip` for creating ZIP archives (if `BUILD_ZIP_ARCHIVE` is set to `true` in `build_and_deploy.sh`)
* Optional: `NSIS` for creating installers (if `BUILD_NSIS_INSTALLER` is set to `true` in `build_and_deploy.sh`)
* Optional: **Ninja**: Required to generate `compile_commands.json` for `clang-tidy`. [Download Ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages)
* Optional: **clang-format** and **clang-tidy**: To use `clang-format` and `clang-tidy`, download the appropriate precompiled binary from the [LLVM Release Page](https://releases.llvm.org/download.html)
<br>

> [!TIP]
> The CMake GUI presents another alternative option to build the project.

> [!NOTE]
> All other dependencies are automatically installed by CMake or the respective script.
<br>

---
<br>

### 2) Setting up
```
git clone https://github.com/Dingola/CppTemplate.git
cd CppTemplate/
```
<br>

---
<br>

### 3) Configuring and Building
```
cmake -B _build -S . -G "Visual Studio 17 2022" -A x64
cd _build
cmake --build . --config Release
```
<br>

---
<br>

### 4) Run the project
```
cd CppTemplate/Release/
./CppTemplate.exe
```
<br>

---
<br>

### 5) Deployment
The project includes scripts for building, testing and deploying the application. These scripts are located in the `Scripts` directory, organized by platform (e.g., `Win` for Windows, `Linux` for Linux).

- **build_release.sh:** Builds the project in release mode.
- **build_and_run_tests.sh:** Builds and runs the test project.
- **build_and_deploy.sh:** Builds and deploys the project. This script can also create a ZIP archive of the deployment directory and/or an NSIS installer using the `installer.nsi` script (Windows only).

To create a ZIP archive of the deployment directory, set `BUILD_ZIP_ARCHIVE` to `true` in `build_and_deploy.sh`.

To create an NSIS installer (Windows only), set `BUILD_NSIS_INSTALLER` to `true` in `build_and_deploy.sh`.
<br><br>

---
<br>

### 6) Using Docker

#### 1. Build the Docker Image
Build the Docker image using the following command:
```
docker build -t cpptemplate-dockerimage .
```
<br>

#### 2. Ways to Run the Docker Image
- **Run directly:**
```
docker run cpptemplate-dockerimage
```
- **Start an interactive Bash shell:**
```
docker run -it cpptemplate-dockerimage bash
```
<br>

#### 3. Run the App or Tests in the Container
- **Start the app:**
```
./_build_app_release/CPP_Project/CppTemplate
```
- **Run the tests:**
```
./_build_tests_release/CPP_Project_Tests/CppTemplate_Tests
```
<br><br><br>

## [Code Style and Linting]

This project uses `clang-format` and `clang-tidy` for code formatting and static analysis.

<br>

### Downloading clang-format and clang-tidy

To use `clang-format` and `clang-tidy`, download the appropriate precompiled binary from the [LLVM Release Page](https://releases.llvm.org/download.html). Here are the recommended files based on your operating system:

- **Windows**: [clang+llvm-18.1.8-x86_64-pc-windows-msvc.tar.xz](https://releases.llvm.org/download.html#18.1.8)
- **Linux**: [clang+llvm-18.1.8-x86_64-linux-gnu-ubuntu-18.04.tar.xz](https://releases.llvm.org/download.html#18.1.8)
- **macOS**: [clang+llvm-18.1.8-arm64-apple-macos11.tar.xz](https://releases.llvm.org/download.html#18.1.8)
<br>

---
<br>

### Configuration

To use `clang-format` and `clang-tidy` in your project, you need to set the following options in your CMake configuration:

- **USE_CLANG_FORMAT**: Enable this option to use `clang-format` for code formatting.
- **USE_CLANG_TIDY**: Enable this option to use `clang-tidy` for static analysis.
- **CLANG_TOOLS_PATH**: Specify the path to the `clang-format` and `clang-tidy` executables.
<br>

---
<br>

### Code Formatting

To format the C++ code and run static analysis, use the following custom targets:

```
_run_clang_format_project
_run_clang_tidy_project
```

To format the C++ code, run the following command after enabling the USE_CLANG_FORMAT option and specifying the path to clang-format:

```
cmake -DUSE_CLANG_FORMAT=ON -DCLANG_TOOLS_PATH="C:/path/to/clang+llvm-18.1.8-x86_64-pc-windows-msvc/bin" ..
cmake --build . --target _run_clang_format_project
cmake --build . --target _run_clang_format_tests
```

To run static analysis with clang-tidy, ensure the USE_CLANG_TIDY option is enabled and the path to clang-tidy is specified:

```
cmake -DUSE_CLANG_TIDY=ON -DCLANG_TOOLS_PATH="C:/path/to/clang+llvm-18.1.8-x86_64-pc-windows-msvc/bin" ..
cmake --build . --target _run_clang_tidy_project
cmake --build . --target _run_clang_tidy_tests
```
<br>

---
<br>

### Generating compile_commands.json

To use `clang-tidy`, you need to generate the `compile_commands.json` file. Run the `generate_compile_commands.sh` script to generate this file:
```
./Scripts/generate_compile_commands.sh
```

> [!NOTE]
> If you encounter the following error:
>
> Ninja Does not match the generator used previously..  Either remove the CMakeCache.txt file and CMakeFiles directory or choose a different binary directory.
>
> This error occurs if the build directory specified in the script already exists and was built with a different generator. Either remove the CMake cache or adjust the script to use a different(/new) build directory.
