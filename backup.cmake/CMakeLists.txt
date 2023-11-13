cmake_minimum_required(VERSION 3.15)

if(MSVC)
  cmake_minimum_required(VERSION 3.10.0) # needed for CMAKE_CXX_STANDARD 17 on >=VS2017.3
endif()

# Seeing our default file path, because this is where our files and cmake modules are going to be located
# They will be put into a cmake or include/<libraryName> directory.
message(STATUS "DEFAULT INSTALL PREFIX PATH ------- ${CMAKE_INSTALL_PREFIX}")


set(PROJECT_NAME Logger)

project(${PROJECT_NAME} VERSION 0.1.0 LANGUAGES C CXX)

# Setting C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)

find_package(formatCpp REQUIRED)

set(INCLUDE_DIR Logger)
include_directories(
    ${PROJECT_SOURCE_DIR}/${INCLUDE_DIR}/include
)

# add_library(${PROJECT_NAME} INTERFACE)
# add_library(FormatCpp ALIAS ${PROJECT_NAME})
add_library(${PROJECT_NAME} INTERFACE)
add_library(logger ALIAS ${PROJECT_NAME}) # Allows to alias the library

include(cmake/boost.cmake)

set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION True)
message(STATUS "Include Path: $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Loggger/include>")
# message(STATUS "Include Path: $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/formatCpp>")
# message(STATUS "Include Path: $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/formatCpp/core>")

target_include_directories(${PROJECT_NAME} INTERFACE "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Logger/include>"
                                                     "$<INSTALL_INTERFACE:include>"
)

install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-targets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

# Installing Logger-configs.cmake to /usr/local/cmake
install(EXPORT ${PROJECT_NAME}-targets
    FILE ${PROJECT_NAME}-config.cmake
    DESTINATION cmake
)

# Installing LoggerFindPackage.cmake to /usr/local/cmake
install(EXPORT ${PROJECT_NAME}-targets
    FILE ${PROJECT_NAME}FindPackage.cmake
    DESTINATION cmake
)

# We need this to tell cmake what files/dependencies that we want to install to our default system filepath
# When we do: sudo make install
# Which our default path is prob going to be: /usr/local/include
# Here is something to NOTE
# When we install and specify the FILE or DIRECTORY, we are basically saying that those files or directories
# are going to be installed to the default path
# To see the default pathh type ccmake ., to see what the CMAKE_INSTALL_PREFIX is.
# install(DIRECTORY include/formatCpp/core DESTINATION include/formatCpp) # Basically we are installing directory core to include/formatCpp when we install it
# We are basically installing "Logger/include" to the /usr/include and specifying when we include Logger to include it as "Logger/include"
install(DIRECTORY Logger/include DESTINATION include/Logger) # Basically we are installing directory core to include/formatCpp when we install it
# install(FILES ${HEADERS} DESTINATION include/formatCpp) # Installing the header files into include/formatCpp