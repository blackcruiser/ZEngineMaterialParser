cmake_minimum_required(VERSION 3.20)

project(MaterialParser)

set(CMAKE_CXX_STANDARD 23)

add_library(Flex INTERFACE)
target_include_directories(Flex INTERFACE E:\\Software\\Devs\\win_flex_bison-2.5.25)

add_executable(MaterialParser MaterialScanner.cpp MaterialParser.cpp Main.cpp)
#target_link_libraries(MaterialParser PRIVATE Flex)