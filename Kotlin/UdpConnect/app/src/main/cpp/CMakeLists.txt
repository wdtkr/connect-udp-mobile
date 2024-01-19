cmake_minimum_required(VERSION 3.4.1)

add_library(udp-native-lib STATIC IMPORTED)
set_target_properties(udp-native-lib PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/lib-udp-android.a)

add_library(native-lib SHARED native-lib.cpp) # JNIラッパーのソースファイル

find_library(log-lib log)

target_link_libraries(native-lib ${log-lib} udp-native-lib)
