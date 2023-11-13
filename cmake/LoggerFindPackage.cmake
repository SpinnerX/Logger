# # # Define project name
# # set(PROJECT_NAME Logger)

# # # Define path of our library headers
# # set(LOGGER_INCLUDE_DIRS 
# #     "/usr/local/include/${PROJECT_NAME}/include/core"
# #     "/usr/local/include/${PROJECT_NAME}/include/common"
# # )

# # # Define path of our library binary
# # set(LOGGER_LIBRARY "/usr/local/lib/lib${PROJECT_NAME}.a")

# # # Now we handle the REQUIRED argument passed to find_package()
# # include(FindPackageHandleStandardArgs)

# # # We use the handle standard arguments to find
# # # if the library and headers are found correctly.
# # find_package_handle_standard_args(
# #     ${PROJECT_NAME}
# #     DEFAULT_MSG
# #     LOGGER_LIBRARY
# #     LOGGER_INCLUDE_DIRS
# # )

# # if(${PROJECT_NAME}_FOUND)
# #     # If logger libraries were found, then we proceed to create
# #     # these cmake variables to be used in the main project.
# #     set(${PROJECT_NAME}_INCLUDE_DIRS ${LOGGER_INCLUDE_DIRS} )
# #     set(${PROJECT_NAME}_LIBRARIES ${LOGGER_LIBRARY} )
# # else()
# #     # If not found, we can set an error message describing what
# #     # files we were searching.
# #     set(${PROJECT_NAME}_ERROR_REASON 
# #         "${PROJECT_NAME} could not be found. Are you sure it is installed in /usr/local? Check that Logger.h exists in /usr/local/include/${PROJECT_NAME}/include/core and MessageQueue.h in /usr/local/include/${PROJECT_NAME}/common. Also, check that libLogger.a exists in /usr/local/lib"
# #     )
# # endif()

# # # make sure these variables are visible in the parent scope
# # mark_as_advanced(${PROJECT_NAME}_INCLUDE_DIRS ${PROJECT_NAME}_LIBRARIES)
# # Define project name
# set(PROJECT_NAME Logger)

# # Mention the relative paths of the headers
# set(Logger_HEADER_DIR ../Logger/include)

# # Try to find the path to the header files
# find_path(Logger_INCLUDE_DIR NAMES ../Logger/include/core/Logger.h ../Logger/include/common/colors.h
#           PATHS ${Logger_HEADER_DIR} 
#           NO_DEFAULT_PATH)

# # Try to find the library file path
# find_library(Logger_LIBRARY NAMES Logger 
#              HINTS ./lib
#              NO_DEFAULT_PATH)

# # Now handle if 'REQUIRED' was specified in find_package() call
# include(FindPackageHandleStandardArgs)
# # find_package_handle_standard_args will handle the REQUIRED arguments of find_package(),
# # and sets LOGGER_FOUND to TRUE if all listed variables contain valid results (found paths).
# find_package_handle_standard_args(${PROJECT_NAME}
#                                   DEFAULT_MSG
#                                   Logger_LIBRARY 
#                                   Logger_INCLUDE_DIR)

# if(LOGGER_FOUND)
#     # If Logger was found, create and set the variables to be exported
#     set(${PROJECT_NAME}_INCLUDE_DIRS ${Logger_HEADER_DIR} ${Logger_INCLUDE_DIR})
#     set(${PROJECT_NAME}_LIBRARIES ${Logger_LIBRARY})
# else()
#     # If Logger was not found, unset the variables
#     set(${PROJECT_NAME}_INCLUDE_DIRS)
#     set(${PROJECT_NAME}_LIBRARIES)
# endif()

# # Mark these for export
# mark_as_advanced(${PROJECT_NAME}_INCLUDE_DIRS ${PROJECT_NAME}_LIBRARIES)
# Debug reporting macro
macro(_fmp_report_debug _msg)
	if(LB_FIND_MY_PACKAGE_DEBUG)
		message("<> ${_msg}")
	endif()
endmacro()

# Figure out which package we are finding
string(FIND "${CMAKE_CURRENT_LIST_FILE}" "/Find" _start REVERSE)
math(EXPR _start "${_start} + 5")
string(SUBSTRING "${CMAKE_CURRENT_LIST_FILE}" ${_start} -1 _package) # strip "/Find"
string(LENGTH "${_package}" _length)
math(EXPR _end "${_length} - 6")
string(SUBSTRING "${_package}" 0 ${_end} _package) # strip ".cmake"
string(REPLACE "/" "::" _package_name "${_package}")
_fmp_report_debug("${_package} | ${_package_name}")

# Avoid double execution
if(${_package}_FOUND)
	return()
endif()

# Error reporting macro
macro(_fmp_report_error _msg)
	if(${_package}_FIND_REQUIRED)
		message(FATAL_ERROR "Find ${_package_name}: ${_msg}")
	elseif(NOT ${_package}_FIND_QUIETLY)
		message(STATUS "Find ${_package_name}: ${_msg}")
	endif()
	set(${_package}_NOT_FOUND_MESSAGE "${_msg}")
endmacro()

# Info reporting macro
macro(_fmp_report_info _msg)
	if(NOT ${_package}_FIND_QUIETLY)
		message(STATUS "Find ${_package_name}: ${_msg}")
	endif()
endmacro()

# Debugging spam
_fmp_report_debug("########")
_fmp_report_debug("${${_package}_FIND_VERSION}")
_fmp_report_debug("${${_package}_FIND_VERSION_EXACT}")
_fmp_report_debug("${${_package}_FIND_VERSION_MAJOR}")
_fmp_report_debug("${${_package}_FIND_VERSION_MINOR}")
_fmp_report_debug("${${_package}_FIND_VERSION_PATCH}")
_fmp_report_debug("${${_package}_FIND_VERSION_TWEAK}")
_fmp_report_debug("${${_package}_FIND_QUIETLY}")
_fmp_report_debug("${${_package}_FIND_REQUIRED}")
_fmp_report_debug("${${_package}_FIND_COMPONENTS}")
foreach(_component ${${_package}_FIND_COMPONENTS})
	if(${_package}_FIND_REQUIRED_${_component})
		_fmp_report_debug("Component ${_component} is REQUIRED")
	else()
		_fmp_report_debug("Component ${_component} is OPTIONAL")
	endif()
endforeach()
_fmp_report_debug("########")

# For CMake GUI
option(${_package}_PREFER_HIGHEST
	"Prefer the highest available version even if a lower version has more requested optional components"
)

# Find where all versions are installed
find_path(${_package}_ROOT
	NAMES
		${_package}
	DOC "This should be the directory that contains ${_package}"
)

_fmp_report_debug("${_package}_ROOT=${${_package}_ROOT}")

# Error out if we could not find the package directory
if("${${_package}_ROOT}" STREQUAL "${_package}_ROOT-NOTFOUND")
	_fmp_report_error("Could not find where versions are stored - please set ${_package}_ROOT")
	return()
elseif(NOT EXISTS "${${_package}_ROOT}")
	_fmp_report_error("Specified root directory does not exist - please check ${_package}_ROOT")
	return()
elseif(NOT IS_DIRECTORY "${${_package}_ROOT}")
	_fmp_report_error("Specified root directory isn't a directory - please check ${_package}_ROOT")
	return()
endif()
set(${_package}_VERSIONS_DIRECTORY "${${_package}_ROOT}/${_package}")
if(NOT EXISTS "${${_package}_VERSIONS_DIRECTORY}")
	unset(${_package}_VERSIONS_DIRECTORY)
	_fmp_report_error("Specified root directory does not contain a ${_package} directory - please check ${_package}_ROOT")
	return()
elseif(NOT IS_DIRECTORY "${${_package}_VERSIONS_DIRECTORY}")
	unset(${_package}_VERSIONS_DIRECTORY)
	_fmp_report_error("${_package} directory is not a directory - please check ${_package}_ROOT")
	return()
endif()

# Get a list of the package versions
file(GLOB ${_package}_VERSIONS
	LIST_DIRECTORIES true
	RELATIVE "${${_package}_VERSIONS_DIRECTORY}"
	"${${_package}_VERSIONS_DIRECTORY}/*"
)

if(LB_FIND_MY_PACKAGE_DEBUG)
	list(SORT ${_package}_VERSIONS)
endif()

_fmp_report_debug("${_package}_VERSIONS=${${_package}_VERSIONS}")

# Error out if there aren't any versions (unusual scenario, but still possible)
if(NOT ${_package}_VERSIONS)
	_fmp_report_error("Could not find package - no versions were detected in ${${_package}_VERSIONS_DIRECTORY}")
	return()
endif()

# Find candidate versions
set(_candidate_versions "")
foreach(_version ${${_package}_VERSIONS})
	# Error out on invalid versions
	string(REGEX MATCH "^[0-9]+(\\.[0-9]+)*$" _match ${_version})
	if("${_match}" STREQUAL "")
		_fmp_report_error("\"${_version}\" is not a valid version - please remove it from ${${_package}_VERSIONS_DIRECTORY}")
		return()
	elseif(NOT IS_DIRECTORY "${${_package}_VERSIONS_DIRECTORY}/${_version}")
		_fmp_report_error("\"${_version}\" is not a directory - please remove it from ${${_package}_VERSIONS_DIRECTORY}")
		return()
	endif()

	# Reset find version vars
	set(_find_version ${${_package}_FIND_VERSION})
	string(REPLACE "." ";" _find_version_list "${_find_version}")
	list(LENGTH _find_version_list _find_version_depth)

	# Reset candidate version vars
	string(REPLACE "." ";" _version_list "${_version}")
	list(LENGTH _version_list _version_depth)

	# Error out on duplicate versions
	foreach(_prev_version ${_candidate_versions})
		if(_prev_version VERSION_EQUAL _version)
			_fmp_report_error("Duplicate versions detected - please remove duplicates (e.g. ${_prev_version} and ${_version}) in ${${_package}_VERSIONS_DIRECTORY}")
			return()
		endif()
	endforeach()

	# Determine if this version is a candidate
	if(_find_version_depth GREATER _version_depth)
		if(${_package}_FIND_VERSION_EXACT)
			continue()
		endif()
	else()
		# Pad find version with components from candidate
		while(_find_version_depth LESS _version_depth)
			list(GET _version_list ${_find_version_depth} _component)
			list(APPEND _find_version_list ${_component})
			list(LENGTH _find_version_list _find_version_depth)
		endwhile()
	endif()
	if(_find_version_list STREQUAL _version_list)
		list(APPEND _candidate_versions ${_version})
		continue()
	elseif(NOT ${_package}_FIND_VERSION_EXACT)
		string(REPLACE ";" "." _find_version "${_find_version_list}")
		if(_find_version VERSION_LESS _version)
			list(APPEND _candidate_versions ${_version})
			continue()
		endif()
	endif()
endforeach()
_fmp_report_debug("_candidate_versions=${_candidate_versions}")

# Error out if we didn't find any candidates
list(LENGTH _candidate_versions _num_candidates)
if(_num_candidates EQUAL 0)
	if(${_package}_FIND_VERSION_EXACT)
		set(_matching "equivalent to")
	else()
		set(_matching "at least")
	endif()
	_fmp_report_error("Could not find any version that was ${_matching} ${${_package}_FIND_VERSION} - available versions: ${${_package}_VERSIONS}")
	return()
endif()

# Filter out versions that don't have all required components
set(_index 0)
while(_index LESS _num_candidates)
	list(GET _candidate_versions ${_index} _version)
	foreach(_component ${${_package}_FIND_COMPONENTS})
		if(${_package}_FIND_REQUIRED_${_component})
			if(NOT EXISTS "${${_package}_VERSIONS_DIRECTORY}/${_version}/cmake/${_package}/${_component}.cmake")
				list(REMOVE_AT _candidate_versions ${_index})
				math(EXPR _index "${_index} - 1")
				_fmp_report_info("Ignoring version ${_version} because it does not have the required component ${_component}")
				break()
			endif()
		endif()
	endforeach()
	math(EXPR _index "0${_index} + 1") # CMake math() cannot handle negative numbers!!
	list(LENGTH _candidate_versions _num_candidates)
endwhile()
_fmp_report_debug("_candidate_versions=${_candidate_versions}")

# Error out if none of the versions had all the required components
list(LENGTH _candidate_versions _num_candidates)
if(_num_candidates EQUAL 0)
	_fmp_report_error("No applicable version has all the required components")
	return()
endif()

if(${_package}_PREFER_HIGHEST)
	set(_preferred_versions "${_candidate_versions}")
else()
	# Prefer versions with the most requested optional components
	set(_preferred_versions "")
	set(_preferred_versions_compnum 0)
	foreach(_version ${_candidate_versions})
		set(_compnum 0)
		# Count present requested optional components
		foreach(_component ${${_package}_FIND_COMPONENTS})
			if(NOT ${_package}_FIND_REQUIRED_${_component})
				if(EXISTS "${${_package}_VERSIONS_DIRECTORY}/${_version}/cmake/${_package}/${_component}.cmake")
					math(EXPR _compnum "${_compnum} + 1")
				endif()
			endif()
		endforeach()
		# Update preferred versions
		if(_compnum GREATER _preferred_versions_compnum)
			set(_preferred_versions ${_version})
			set(_preferred_versions_compnum ${_compnum})
		elseif(_compnum EQUAL _preferred_versions_compnum)
			list(APPEND _preferred_versions ${_version})
		endif()
	endforeach()
	_fmp_report_debug("_preferred_versions=${_preferred_versions}")

	# Error out if we made a mistake in our logic above
	# (worst case should be that _preferred_versions is the same as _candidate_versions)
	list(LENGTH _preferred_versions _num_preferred)
	if(_num_preferred EQUAL 0)
		message(FATAL_ERROR "Something has gone wrong the code in Find${_package}.cmake")
		return()
	endif()
endif()

# Finally, select the highest version
list(GET _preferred_versions 0 _preferred_version)
foreach(_version ${_preferred_versions})
	if(_version VERSION_GREATER _preferred_version)
		set(_preferred_version ${_version})
	endif()
endforeach()
_fmp_report_debug("_preferred_version=${_preferred_version}")

# Load the version and report findings
include("${${_package}_VERSIONS_DIRECTORY}/${_preferred_version}/cmake/${_package}.cmake")
set(_components "")
foreach(_component ${${_package}_FIND_COMPONENTS})
	set(_comp_path "${${_package}_VERSIONS_DIRECTORY}/${_preferred_version}/cmake/${_package}/${_component}.cmake")
	if(EXISTS "${_comp_path}")
		include("${_comp_path}")
		list(APPEND _components ${_component})
		set(${_package}_${_component}_FOUND 1)
	endif()
endforeach()
set(${_package}_FOUND 1)
set(${_package}_VERSION "${_preferred_version}")
set(${_package}_VERSION_STRING "${_preferred_version}")
string(REPLACE "." ";" _preferred_version_list "${_preferred_version}")
list(LENGTH _preferred_version_list _preferred_version_depth)
list(GET _preferred_version_list 0 ${_package}_VERSION_MAJOR)
if(_preferred_version_depth GREATER 1)
	list(GET _preferred_version_list 1 ${_package}_VERSION_MINOR)
	if(_preferred_version_depth GREATER 2)
		list(GET _preferred_version_list 2 ${_package}_VERSION_PATCH)
		if(_preferred_version_depth GREATER 3)
			list(GET _preferred_version_list 3 ${_package}_VERSION_TWEAK)
		endif()
	endif()
endif()
set(${_package}_ROOT_DIR "${${_package}_VERSIONS_DIRECTORY}/${_preferred_version}")
string(REPLACE ";" ", " _components "${_components}")
if(_components STREQUAL "")
	_fmp_report_info("Found version ${_preferred_version} with no components")
else()
	_fmp_report_info("Found version ${_preferred_version} with components (${_components})")
endif()
return()

# Done!