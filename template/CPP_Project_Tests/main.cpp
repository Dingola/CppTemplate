/**
 * @file main.cpp
 * @brief Main entry point for the test project using Google Test.
 */

#include <gtest/gtest.h>

 /**
  * @brief Initializes and runs all Google Test unit tests.
  *
  * This function sets up the Google Test framework and executes all registered tests.
  *
  * @param argc Number of command-line arguments.
  * @param argv Array of command-line arguments.
  * @return The result of the test run (0 if all tests pass, otherwise non-zero).
  */
auto main(int argc, char* argv[]) -> int
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
