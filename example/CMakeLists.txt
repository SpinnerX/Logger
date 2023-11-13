cmake_minimum_required(VERSION 3.15)

set(PROJECT_NAME example)

project(${PROJECT_NAME} VERSION 0.1.0 LANGUAGES C CXX)

# Setting C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)

find_package(Logger REQUIRED)

# Better way instead of GLOBBING 
set(
    all_src
    ${PROJECT_SOURCE_DIR}/main.cpp
)

add_executable(${PROJECT_NAME} ${all_src})

target_link_libraries(${PROJECT_NAME} Logger)