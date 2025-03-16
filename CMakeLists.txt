cmake_minimum_required(VERSION 3.10)

project(
    XPwm
    VERSION 1.1.6
    DESCRIPTION "Local Password manager using OpenSSL and Qt"
    HOMEPAGE_URL "https://github.com/SFENX-Group/XPwm"
    LANGUAGES CXX)

set(PROJECT_ORGANIZATION "SFENX")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

add_subdirectory(lib) # compile libs
add_subdirectory(res) # icon and .desktop file for gnu/linux

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
add_compile_options(-fno-sized-deallocation)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets LinguistTools)

if(Qt5Widgets_FOUND)
    message(STATUS "Qt version: ${Qt5Widgets_VERSION}")
elseif(Qt6Widgets_FOUND)
    message(STATUS "Qt version: ${Qt6Widgets_VERSION}")
else()
    message(FATAL_ERROR "Qt5Widgets or Qt6Widgets not found")
endif()

configure_file(./include/Config.hpp.cmake ${CMAKE_CURRENT_BINARY_DIR}/Config.hpp)

# 4 - add qm file to qrc file and load it in code
file(GLOB_RECURSE CPP_FILES "src/*.cpp")
file(GLOB_RECURSE HPP_FILES "include/*.hpp")
file(GLOB_RECURSE UI_FILES "design/*.ui")
file(GLOB_RECURSE QRC_FILES "**/*.qrc")

file(GLOB_RECURSE TS_FILES "translations/*.ts")

set(PROJECT_SOURCES
    ${CPP_FILES} ${HPP_FILES} ${UI_FILES} ${QRC_FILES}
)

set(LANGS tr de)

# 1 - first create an translation file to translate texts.
set(QM_FILES "")

foreach(LANG ${LANGS})
    qt_create_translation(QM_FILE ${CMAKE_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/translations/translation_${LANG}.ts)
    list(APPEND QM_FILES ${QM_FILE})
endforeach()

# 2 - translate files using linguist

# 3 - after translate and build we should configure file to get file to correct directory
foreach(QM_FILE ${QM_FILES})
    if(EXISTS ${QM_FILE})
        configure_file(${QM_FILE} ${CMAKE_SOURCE_DIR}/translations COPYONLY)
    else()
        list(APPEND PROJECT_SOURCES ${TS_FILES} ${QM_FILES})
    endif()
endforeach()

if(WIN32)
    set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/res/icon.rc")
    list(APPEND PROJECT_SOURCES ${app_icon_resource_windows})
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )

# Define target properties for Android with Qt 6 as:
# set_property(TARGET xpwm APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
# CMAKE_CURRENT_SOURCE_DIR/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(${PROJECT_NAME} SHARED
            ${PROJECT_SOURCES}
        )

    # Define properties for Android with Qt 5 after find_package() calls as:
    # set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(${PROJECT_NAME}
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Widgets Singleton Cipher JSONHandler Logger)
target_include_directories(${PROJECT_NAME} PRIVATE include)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER https://xaprier.dev
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(WIN32)
    install(TARGETS ${PROJECT_NAME}
        BUNDLE DESTINATION .
        RUNTIME DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
else()
    install(TARGETS ${PROJECT_NAME}
        BUNDLE DESTINATION .
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endif()

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(${PROJECT_NAME})
endif()

if(WIN32)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:Cipher>
        $<TARGET_FILE:JSONHandler>
        $<TARGET_FILE:Logger>
        $<TARGET_FILE_DIR:${PROJECT_NAME}>
    )
endif()
