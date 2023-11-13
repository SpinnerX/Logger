
################################################################################################################################

#<library_name>Config.cmake
# This allows us to configure the library
# Meaning, by showing CMake where all our source, files, dependencies are going to be located
# in our file structures

################################################################################################################################

# configure_file(
#   ${CMAKE_SOURCE_DIR}/LibraryFindPackage/version.h.in
#   ${CMAKE_BINARY_DIR}/LibraryFindPackage/version.h
#   @ONLY
# )

# list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Logger")
# set(LOGGER_FIND_PACKAGE_DIR ${CMAKE_CURRENT_LIST_DIR})
# include("oggerFindPackage.cmake")
message("Logger_LIBRARY ---------------------------------- ${CMAKE_CURRENT_LIST_DIR}/include")
message("Logger_LIBRARY ---------------------------------- ${CMAKE_CURRENT_LIST_DIR}/lib/libLogger.so")
message("--==__--=>?Prining CMAKE_CURRENT_LIST_DIR ===========> ${CMAKE_CURRENT_LIST_DIR}")
set(Logger_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../include")
set(Logger_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/../lib/libLogger.so")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Logger REQUIRED_VARS Logger_INCLUDE_DIR Logger_LIBRARY)

# Reset the CMake module path to its state when this script was called.
set(LIBRARY_NAME Logger)
set(CMAKE_MODULE_PATH ${CALLERS_CMAKE_MODULE_PATH})
set(INCLUDE_DIR ${LIBRARY_NAME}/include)
# set(LIBRARY_FIND_PACKAGE_INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/${INCLUDE_DIR}"  "${CMAKE_INSTALL_PREFIX}/include/formatCpp" "${CMAKE_INSTALL_PREFIX}/include/formatCpp/core")
set(LIBRARY_FIND_PACKAGE_INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/${INCLUDE_DIR}")
set(LIBRARY_FIND_PACKAGE_LIBRARIES "${CMAKE_INSTALL_PREFIX}/lib/lib${PROJECT_NAME}.a")

# Provide the include and library directories to the config file
list(APPEND LIBRARYFINDPACKAGE_INCLUDE_DIRS "${LIBRARY_FIND_PACKAGE_INCLUDE_DIRS}")
set(LIBRARYFINDPACKAGE_INCLUDE_DIRS ${LIBRARY_FIND_PACKAGE_INCLUDE_DIRS} PARENT_SCOPE)
set(LIBRARYFINDPACKAGE_LIBRARIES ${LIBRARY_FIND_PACKAGE_LIBRARIES} PARENT_SCOPE)

# These are going to let cmake know that when we configure this project
# We are going to tell CMake, that here are our configuration cmake files for the library.
set(
  LIBRARY_MODULE_FILES
  ${PROJECT_NAME}FindPackageConfig.cmake
)

## find relative path to make package relocatable
# this is a bit involved to handle these cases:
#   - CMAKE_INSTALL_LIBDIR is overridden by the user
#   - CMAKE_INSTALL_LIBDIR contains multiple levels for Debian multiarch support
if (IS_ABSOLUTE "${CMAKE_INSTALL_PREFIX}")
  set(ABS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
else()
  get_filename_component(ABS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" ABSOLUTE)
endif()


target_include_directories(${PROJECT_NAME} INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)

set(LOGGER_FIND_PACKAGE_DIR ${CMAKE_CURRENT_LIST_DIR})
include("${LOGGER_FIND_PACKAGE_DIR}/LoggerFindPackage.cmake")