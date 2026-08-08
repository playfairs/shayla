cmake_minimum_required(VERSION 3.25)
project(Shayla LANGUAGES CXX OBJCXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
if(NOT APPLE)
  message(FATAL_ERROR "Shayla currently supports only macOS")
endif()
add_executable(Shayla
  src/main.cpp
  platform/macos/application.mm
  platform/macos/overlay.mm
)
target_include_directories(Shayla PRIVATE include)
target_link_libraries(Shayla PRIVATE
  "-framework AppKit"
  "-framework Foundation"
  "-framework CoreGraphics"
)
set_target_properties(Shayla PROPERTIES
  MACOSX_BUNDLE TRUE
)
