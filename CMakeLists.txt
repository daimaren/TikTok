cmake_minimum_required(VERSION 3.6)

set(APP_NAME cpp-tests)

project(${APP_NAME})

if(NOT DEFINED BUILD_ENGINE_DONE)
    set(TIKTOK_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    set(CMAKE_MODULE_PATH ${TIKTOK_ROOT_PATH}/cmake/Modules/)

    include(CocosBuildSet)
    add_subdirectory(${TIKTOK_ROOT_PATH}/cocos ${ENGINE_BINARY_PATH}/cocos/core)
endif()

# record sources, headers, resources...
set(TIKTOK_SOURCE)
set(TIKTOK_HEADER)

set(TIKTOK_RES_FOLDER
    "${CMAKE_CURRENT_SOURCE_DIR}/Resources"
    )
if(APPLE OR VS)
    cocos_mark_multi_resources(cc_common_res RES_TO "Resources" FOLDERS ${TIKTOK_RES_FOLDER})
endif()

if(ANDROID)
    # change APP_NAME to the share library name for Android, it's value depend on AndroidManifest.xml
    set(APP_NAME cpp_tests)
    list(APPEND TIKTOK_HEADER
         Classes/JNITest/JNITest.h
         )
    list(APPEND TIKTOK_SOURCE
         Classes/JNITest/JNITest.cpp
         proj.android/app/jni/main.cpp
         ) 
elseif(APPLE)
    if(IOS)
        list(APPEND TIKTOK_HEADER
             proj.ios/Classes/testsAppDelegate.h
             proj.ios/Classes/RootViewController.h
             )
        set(APP_UI_RES
            proj.ios/LaunchScreen.storyboard
            proj.ios/LaunchScreenBackground.png
            proj.ios/Images.xcassets
            )
        list(APPEND TIKTOK_SOURCE
             proj.ios/main.m
             proj.ios/Classes/testsAppDelegate.mm
             proj.ios/Classes/RootViewController.mm
             proj.ios/Prefix.pch
             ${APP_UI_RES}
             )
    endif()
    list(APPEND TIKTOK_SOURCE ${cc_common_res})
endif()

if(ANDROID OR IOS)

endif()

# mark app complie info and libs info
set(all_code_files
    ${TIKTOK_HEADER}
    ${TIKTOK_SOURCE}
    )

if(NOT ANDROID)
    add_executable(${APP_NAME} ${all_code_files})
else()
    add_library(${APP_NAME} SHARED ${all_code_files})
    add_subdirectory(${TIKTOK_ROOT_PATH}/cocos/platform/android ${ENGINE_BINARY_PATH}/cocos/platform)
    target_link_libraries(${APP_NAME} -Wl,--whole-archive cpp_android_spec -Wl,--no-whole-archive)
endif()

target_link_libraries(${APP_NAME} cocos2d)
target_include_directories(${APP_NAME}
        PRIVATE Classes
)

# mark app resources
setup_cocos_app_config(${APP_NAME})
if(APPLE)
    set_target_properties(${APP_NAME} PROPERTIES RESOURCE "${APP_UI_RES}")
    if(IOS)
        cocos_pak_xcode(${APP_NAME} INFO_PLIST "iOSBundleInfo.plist.in")
        set_xcode_property(${APP_NAME} ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon-${APP_NAME}")
    endif()
endif()
