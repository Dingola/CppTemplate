# Project Overview

This project is a C++20 template for applications and libraries.
It supports cross-platform builds on Windows, Linux, and macOS and provides optional Docker integration.
The project is split into a main project (`CPP_Project`) and an optional test project (`CPP_Project_Tests`), both managed with CMake.

## Folder Structure

- `/CPP_Project`
  - `/Headers` - public headers
  - `/Headers/Private` - private implementation headers
  - `/Sources` - implementation files
  - `/Resources` - non-code project resources
  - `/ThirdParty` - CMake files for project dependencies
- `/CPP_Project_Tests` - test project with headers, sources, and third-party test dependencies
- `/CMake` - shared CMake modules
- `/Configs` - clang-tidy, clang-format, and Doxygen configuration
- `/Scripts` - platform-specific build and deployment scripts
- `/Dockerfile` - Docker build configuration

## Libraries and Frameworks

- C++20
- CMake 3.29.3 or newer
- GoogleTest and GoogleMock for tests
- Optional:
  - clang-format and clang-tidy for linting
  - Doxygen for documentation
  - Docker for containerized builds

## Coding Standards

- Use `snake_case` for variable and function names.
- Use trailing return types for all functions, for example `auto foo() -> int`.
- Use only one return statement per method, at the end of the method.
  - Exception: `void` methods must not use `return`.
- Avoid using `break` and `continue`.
- Use `[[nodiscard]]` on functions where ignoring the return value would be a logical error or make the function call meaningless.
  - If `[[nodiscard]]` is added, the Doxygen documentation must clearly describe the importance of the return value.
- Keep public headers in `/CPP_Project/Headers` and private headers in `/CPP_Project/Headers/Private`.
- Keep implementation files in `/CPP_Project/Sources` and mirror the public folder structure where applicable.
- Getter methods must start with `get`, for example `get_value()`.
- Setter methods must start with `set`, for example `set_value(int new_value)`.

## Documentation Rules

- Generate Doxygen documentation for both headers (`.h`) and implementation files (`.cpp`).
- Write all documentation in English.
- Accompany every code change or addition, such as a new class, method, parameter, or option, with updated Doxygen documentation.
- When making changes, show exactly where documentation was added, updated, or removed so that code and documentation remain synchronized.

## Build and Test Guidelines

- Use the existing CMake options to configure target type, tests, sanitizers, formatting, linting, and documentation.
- Keep tests under `CPP_Project_Tests` and mirror the structure of the main project where applicable.
- Build the main target as a static library when linking it into the test executable.
- Keep coverage filtering scoped to production sources under `CPP_Project`.
