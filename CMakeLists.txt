cmake_minimum_required(VERSION 3.16)

project(FOODIEZ VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appFOODIEZ
    main.cpp
)

file(GLOB_RECURSE image_files
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    Assets/*.*)

# Remove .DS_Store or any unwanted files
list(FILTER image_files EXCLUDE REGEX ".*\\.DS_Store$")
list(FILTER image_files EXCLUDE REGEX "^\\..*")  # Optional: exclude all dotfiles

qt_add_resources(appFOODIEZ "images"
    FILES ${image_files}
)

qt_add_qml_module(appFOODIEZ
    URI FOODIEZ
    VERSION 1.0
    QML_FILES main.qml
    QML_FILES Assets/pages/Login.qml
    QML_FILES Assets/pages/MainContent.qml
    QML_FILES Assets/pages/Home.qml
    QML_FILES Assets/pages/Explore.qml
    QML_FILES Assets/pages/Create.qml
    QML_FILES Assets/pages/Reels.qml
    QML_FILES Assets/pages/Profile.qml
    RESOURCES resources.qrc

    SOURCES Loginauthentication.h Loginauthentication.cpp

    QML_FILES Assets/components/PostItem.qml
    QML_FILES Assets/components/StoryItem.qml
    SOURCES Postmodel.h Postmodel.cpp
    SOURCES Exploremodel.h Exploremodel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appFOODIEZ PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appFOODIEZ
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFOODIEZ
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appFOODIEZ
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
