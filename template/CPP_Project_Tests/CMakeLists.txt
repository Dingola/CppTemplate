cmake_minimum_required(VERSION 3.29.3 FATAL_ERROR)

############################################
### Setup project                        ###
############################################

project(${MAIN_PROJECT_NAME}_Tests LANGUAGES CXX VERSION ${MAIN_PROJECT_VERSION})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Include CMake helper scripts
include(${CMAKE_SOURCE_DIR}/CMake/SourceGroups.cmake)
include(${CMAKE_SOURCE_DIR}/CMake/BuildThirdPartyProject.cmake)
include(${CMAKE_SOURCE_DIR}/CMake/IncludeThirdParty.cmake)

############################################
### Global Properties                    ###
############################################

# Disable CMake searching for modules
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

# Global properties for project organization
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Include current directory
set(CMAKE_INCLUDE_CURRENT_DIR ON)

############################################
### Documentation Configuration          ###
############################################

# Set the documentation sub-target name
set(DOC_OPTION_NAME ${MAIN_PROJECT_NAME}_Tests)
set(DOC_TARGET_NAME tests)

############################################
### Setup Project File Includes          ###
############################################

file(GLOB_RECURSE ${PROJECT_NAME}_HEADERS CONFIGURE_DEPENDS
     "Headers/*.h"
)

file(GLOB_RECURSE ${PROJECT_NAME}_SOURCES CONFIGURE_DEPENDS
     "main.cpp"
     "Sources/*.cpp"
)

include_directories(Headers Sources)

############################################
### Clang-Format Configuration           ###
############################################

if(USE_CLANG_FORMAT)
    find_program(CLANG_FORMAT "clang-format" HINTS ${CLANG_TOOLS_PATH})
    if(CLANG_FORMAT)
        # Define a custom target for formatting code
        add_custom_target(${PROJECT_NAME}_run_clang_format_tests
            COMMAND ${CLANG_FORMAT}
            -style=file:${CMAKE_SOURCE_DIR}/Configs/.clang-format
            -i
            ${${PROJECT_NAME}_HEADERS}
            ${${PROJECT_NAME}_SOURCES}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Formatting code with clang-format"
        )
        set_target_properties(${PROJECT_NAME}_run_clang_format_tests PROPERTIES FOLDER "_Tasks")
    else()
        message(WARNING "clang-format not found. Please ensure clang-format is installed and the path is set correctly.")
    endif()
endif()

############################################
### Clang-Tidy Configuration             ###
############################################

if(USE_CLANG_TIDY)
    find_program(CLANG_TIDY "clang-tidy" HINTS ${CLANG_TOOLS_PATH})
    if(CLANG_TIDY)
        # Define a custom target for running clang-tidy
        add_custom_target(${PROJECT_NAME}_run_clang_tidy_tests
            COMMAND ${CLANG_TIDY}
			--config-file=${CMAKE_SOURCE_DIR}/Configs/.clang-tidy
            -p=${CMAKE_BINARY_DIR}
            ${${PROJECT_NAME}_HEADERS}
            ${${PROJECT_NAME}_SOURCES}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Running clang-tidy for static analysis"
        )
        set_target_properties(${PROJECT_NAME}_run_clang_tidy_tests PROPERTIES FOLDER "_Tasks")
    else()
        message(WARNING "clang-tidy not found. Please ensure clang-tidy is installed and the path is set correctly.")
    endif()
endif()

############################################
### Configuration Information            ###
############################################

message(STATUS "###############################################################")
message(STATUS "###          Configuration Information")
message(STATUS "###          Project: ${PROJECT_NAME}")
message(STATUS "###############################################################")
message(STATUS "")
message(STATUS "  CMake Version:                ${CMAKE_VERSION}")
message(STATUS "  CMake Prefix Path:            ${CMAKE_PREFIX_PATH}")
message(STATUS "  CMake Install Prefix Path:    ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  Host System Name:             ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "  Host System Version:          ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "  Target System Name:           ${CMAKE_SYSTEM_NAME}")
message(STATUS "  Target System Version:        ${CMAKE_SYSTEM_VERSION}")
message(STATUS "  Source Directory:             ${CMAKE_SOURCE_DIR}")
message(STATUS "  Build Type:                   ${CMAKE_BUILD_TYPE}")
message(STATUS "  Toolchain File:               ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "  C++ Compiler:                 ${CMAKE_CXX_COMPILER}")
message(STATUS "  C Compiler:                   ${CMAKE_C_COMPILER}")
message(STATUS "  Build Tool:                   ${CMAKE_BUILD_TOOL}")
message(STATUS "  Module Path:                  ${CMAKE_MODULE_PATH}")
message(STATUS "  Binary Directory:             ${CMAKE_BINARY_DIR}")
message(STATUS "  Current Source Directory:     ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "  Current Binary Directory:     ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "")
message(STATUS "-----------------------------------------------")
message(STATUS "")
message(STATUS "  Third Party Include Directory:            ${THIRD_PARTY_INCLUDE_DIR}")
message(STATUS "  ${doc_sub_target_name}_BUILD_DOC:          ${${doc_sub_target_name}_BUILD_DOC}")
message(STATUS "")
message(STATUS "-----------------------------------------------")
message(STATUS "")
message(STATUS "###############################################################")

############################################
### Setup executable build               ###
############################################

add_executable(${PROJECT_NAME})

include(${CMAKE_CURRENT_SOURCE_DIR}/ThirdParty/Doxygen.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/ThirdParty/GoogleTest.cmake)

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${MAIN_PROJECT_NAME}_Tests)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)

target_sources(${PROJECT_NAME}
    PRIVATE
		${${PROJECT_NAME}_HEADERS}
		${${PROJECT_NAME}_SOURCES}
)

############################################
### Setup source groups                  ###
############################################

group_files("${${PROJECT_NAME}_SOURCES}" "Source Files")
group_files("${${PROJECT_NAME}_HEADERS}" "Header Files")

# Specifies include libraries
target_link_libraries(${PROJECT_NAME} PUBLIC ${MAIN_PROJECT_NAME})

# Specifies include directories to use when compiling a given target
target_include_directories(${PROJECT_NAME} PUBLIC 
	${CMAKE_CURRENT_LIST_DIR} 
	${CMAKE_SOURCE_DIR}/CPP_Project/Headers)
