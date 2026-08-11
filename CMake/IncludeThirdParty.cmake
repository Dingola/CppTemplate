# Macro to handle third-party library integration (download, build, and include).
# Usage:
#   include_third_party_library(
#       TARGET_NAME       <Name of the library, e.g. MyLibrary>
#       GIT_URL           <Git URL to clone>
#       GIT_TAG           <Git tag or branch>
#       LINK_TYPE         <PUBLIC/PRIVATE/INTERFACE>
#   )
macro(include_third_party_library TARGET_NAME GIT_URL GIT_TAG LINK_TYPE)

    # 1. Setup paths and variables
    set(PROJECT_DIR_NAME "${TARGET_NAME}_${GIT_TAG}")
    set(TARGET_DIR "${THIRD_PARTY_INCLUDE_DIR}/${PROJECT_DIR_NAME}")
    set(INSTALL_ROOT "${TARGET_DIR}/${TARGET_NAME}_install")

    # Define standard variables for the library paths
    set(${TARGET_NAME}_INSTALL_ROOT "${INSTALL_ROOT}")
    set(${TARGET_NAME}_INCLUDE_DIR  "${INSTALL_ROOT}/${CMAKE_BUILD_TYPE}/include")
    set(${TARGET_NAME}_LIBRARY      "${INSTALL_ROOT}/${CMAKE_BUILD_TYPE}/lib/${TARGET_NAME}.lib")
    set(${TARGET_NAME}_DIR          "")

    # 2. Add search paths for this library and any other already installed libraries
    file(GLOB ALL_INSTALLED_PATHS
        "${THIRD_PARTY_INCLUDE_DIR}/*/*_install/${CMAKE_BUILD_TYPE}"
        "${THIRD_PARTY_INCLUDE_DIR}/*/*_install"
    )
    list(APPEND CMAKE_PREFIX_PATH ${ALL_INSTALLED_PATHS} "${INSTALL_ROOT}/${CMAKE_BUILD_TYPE}")

    # 3. Status flags
    set(SHOULD_ADD_SOURCE ON)
    set(PACKAGE_FOUND_INSTALLED OFF)

    # 4. Try to find the installed package first unless source inclusion is forced
    if(NOT ${MAIN_PROJECT_NAME}_INCLUDE_THIRD_LIBS_INTO_SOLUTION)
        find_package(${TARGET_NAME} HINTS ${INSTALL_ROOT}/${CMAKE_BUILD_TYPE}/lib/cmake/${TARGET_NAME} NO_DEFAULT_PATHS)

        # Access the result variable dynamically
        if(${TARGET_NAME}_FOUND)
            message(STATUS "[${TARGET_NAME}] Found installed package. Skipping download/source inclusion.")
            set(SHOULD_ADD_SOURCE OFF)
            set(PACKAGE_FOUND_INSTALLED ON)
        endif()
    endif()

    # 5. Download and build if forced or not found installed
    if(SHOULD_ADD_SOURCE)
        if(NOT EXISTS "${TARGET_DIR}/${TARGET_NAME}_src/CMakeLists.txt")
            message(STATUS "[${TARGET_NAME}] Source not found (or forced refresh). Downloading...")
        else()
            message(STATUS "[${TARGET_NAME}] Checking/updating library...")
        endif()

        set(CMAKE_ARGS "-D ${TARGET_NAME}_BUILD_TARGET_TYPE:STRING=static_library -D MAIN_PROJECT_NAME:STRING=${TARGET_NAME}")

        build_third_party_project(
            false
            ${TARGET_NAME}
            ${GIT_URL}
            ${GIT_TAG}
            ${TARGET_DIR}
            ${CMAKE_BUILD_TYPE}
            ${CMAKE_ARGS}
        )
    endif()

    # 6. Integrate the dependency
    if(${MAIN_PROJECT_NAME}_INCLUDE_THIRD_LIBS_INTO_SOLUTION)
        # Add source code directly to the solution
        if(EXISTS "${TARGET_DIR}/${TARGET_NAME}_src/CMakeLists.txt")
            message(STATUS "[${TARGET_NAME}] Adding source to solution (enabled via ${MAIN_PROJECT_NAME}_INCLUDE_THIRD_LIBS_INTO_SOLUTION)...")

            set(BACKUP_MAIN_PROJECT_NAME ${MAIN_PROJECT_NAME})
            set(MAIN_PROJECT_NAME ${TARGET_NAME})

            # Force a static library build for the subproject
            set(${TARGET_NAME}_BUILD_TARGET_TYPE "static_library" CACHE STRING "Force static library" FORCE)

            add_subdirectory(
                "${TARGET_DIR}/${TARGET_NAME}_src"
                "${CMAKE_BINARY_DIR}/ThirdParty/${TARGET_NAME}_Solution"
                EXCLUDE_FROM_ALL
            )

            set(MAIN_PROJECT_NAME ${BACKUP_MAIN_PROJECT_NAME})
        else()
            message(FATAL_ERROR "[${TARGET_NAME}] Source code is missing even after the download attempt.")
        endif()

    else()
        # Use the installed binary package
        if(NOT PACKAGE_FOUND_INSTALLED)

            # Refresh search paths for transitive dependencies
            file(GLOB NEWLY_INSTALLED_PATHS
                "${THIRD_PARTY_INCLUDE_DIR}/*/*_install/${CMAKE_BUILD_TYPE}"
                "${THIRD_PARTY_INCLUDE_DIR}/*/*_install"
            )
            list(APPEND CMAKE_PREFIX_PATH ${NEWLY_INSTALLED_PATHS})

            find_package(${TARGET_NAME} HINTS ${INSTALL_ROOT}/${CMAKE_BUILD_TYPE}/lib/cmake/${TARGET_NAME} NO_DEFAULT_PATHS)

            if(${TARGET_NAME}_FOUND)
                message(STATUS "[${TARGET_NAME}] Found package after build.")
            else()
                message(FATAL_ERROR "[${TARGET_NAME}] Failed to find package even after build.")
            endif()
        endif()
    endif()

    # 7. Link the library
    target_link_libraries(${PROJECT_NAME} ${LINK_TYPE} ${TARGET_NAME})

endmacro()
