cmake_minimum_required(VERSION 3.20)
project(GEMiniRecomp CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(GBARECOMP_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../gbarecomp"
    CACHE PATH "Path to the gbarecomp runtime checkout")
set(GEMINI_BIOS_PATH "" CACHE FILEPATH
    "User-provided GBA BIOS to stage beside GEMiniRecomp.exe")
if(NOT EXISTS "${GBARECOMP_ROOT}/CMakeLists.txt")
    message(FATAL_ERROR
        "GBARECOMP_ROOT does not point to a gbarecomp checkout: ${GBARECOMP_ROOT}")
endif()

set(GEMINI_SDL2_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/third_party/SDL2/SDL2-2.32.10/x86_64-w64-mingw32"
    CACHE PATH "Local SDL2 MinGW package")
if(EXISTS "${GEMINI_SDL2_ROOT}/include/SDL2/SDL.h")
    set(GBARECOMP_MINGW_PREFIX_UNIX "${GEMINI_SDL2_ROOT}"
        CACHE PATH "SDL2 package root used by gbarecomp" FORCE)
endif()
set(GEMINI_TOMLPP_INCLUDE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../tomlplusplus/include/toml++")
if(EXISTS "${GEMINI_TOMLPP_INCLUDE_DIR}/toml.hpp")
    set(GBARECOMP_TOMLPP_INCLUDE_DIR "${GEMINI_TOMLPP_INCLUDE_DIR}"
        CACHE PATH "toml++ include directory used by gbarecomp" FORCE)
endif()

add_subdirectory("${GBARECOMP_ROOT}" gbarecomp_build EXCLUDE_FROM_ALL)

if(CMAKE_CXX_COMPILER)
    get_filename_component(GEMINI_COMPILER_BIN
        "${CMAKE_CXX_COMPILER}" DIRECTORY)
    set(GEMINI_MINGW_RUNTIME_BIN "C:/msys64/mingw64/bin")
    if(NOT EXISTS "${GEMINI_MINGW_RUNTIME_BIN}/libwinpthread-1.dll")
        set(GEMINI_MINGW_RUNTIME_BIN "${GEMINI_COMPILER_BIN}")
    endif()
    set(GBARECOMP_MINGW_RUNTIME_BIN "${GEMINI_MINGW_RUNTIME_BIN}"
        CACHE PATH "Compiler directory containing runtime DLLs" FORCE)
endif()

file(GLOB GBARECOMP_SHARDS CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/generated/recompiled_*.cpp"
)
set(GBARECOMP_GENERATED ${GBARECOMP_SHARDS}
    "${CMAKE_CURRENT_SOURCE_DIR}/generated/dispatch_table.cpp"
)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/generated/symbol_map.cpp")
    list(APPEND GBARECOMP_GENERATED
        "${CMAKE_CURRENT_SOURCE_DIR}/generated/symbol_map.cpp")
endif()

add_executable(GEMiniRecomp
    main.cpp
    ${GBARECOMP_GENERATED}
)
target_include_directories(GEMiniRecomp PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/generated"
    "${GBARECOMP_ROOT}/src/armv4t"
    "${GBARECOMP_ROOT}/src/gba"
    "${GBARECOMP_ROOT}/src/runtime"
    "${GBARECOMP_ROOT}/src/debug"
)
target_link_libraries(GEMiniRecomp PRIVATE
    gbarecomp_runtime
    gbarecomp_debug
    gbarecomp_gba
    gbarecomp_armv4t
)

if(MSVC)
    target_link_options(GEMiniRecomp PRIVATE /STACK:16777216)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_link_options(GEMiniRecomp PRIVATE -Wl,/STACK:16777216)
elseif(MINGW OR WIN32 OR CMAKE_SYSTEM_NAME STREQUAL "MSYS")
    target_link_options(GEMiniRecomp PRIVATE -Wl,--stack,16777216)
endif()

gbarecomp_stage_mingw_runtime(GEMiniRecomp)

if(WIN32 AND GEMINI_COMPILER_BIN)
    foreach(gemini_runtime_dll IN ITEMS libc++.dll libunwind.dll)
        if(EXISTS "${GEMINI_COMPILER_BIN}/${gemini_runtime_dll}")
            add_custom_command(TARGET GEMiniRecomp POST_BUILD
                COMMAND "${CMAKE_COMMAND}" -E copy_if_different
                    "${GEMINI_COMPILER_BIN}/${gemini_runtime_dll}"
                    "$<TARGET_FILE_DIR:GEMiniRecomp>/${gemini_runtime_dll}")
        endif()
    endforeach()
endif()

if(WIN32 AND EXISTS "${GEMINI_MINGW_RUNTIME_BIN}")
    foreach(gemini_gcc_dll IN ITEMS
            libgmp-10.dll libisl-23.dll libmpc-3.dll libmpfr-6.dll
            libzstd.dll zlib1.dll libintl-8.dll libiconv-2.dll)
        if(EXISTS "${GEMINI_MINGW_RUNTIME_BIN}/${gemini_gcc_dll}")
            add_custom_command(TARGET GEMiniRecomp POST_BUILD
                COMMAND "${CMAKE_COMMAND}" -E copy_if_different
                    "${GEMINI_MINGW_RUNTIME_BIN}/${gemini_gcc_dll}"
                    "$<TARGET_FILE_DIR:GEMiniRecomp>/${gemini_gcc_dll}")
        endif()
    endforeach()
endif()

if(WIN32 AND EXISTS "${GEMINI_SDL2_ROOT}/bin/SDL2.dll")
    add_custom_command(TARGET GEMiniRecomp POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different
            "${GEMINI_SDL2_ROOT}/bin/SDL2.dll"
            "$<TARGET_FILE_DIR:GEMiniRecomp>/SDL2.dll")
endif()

add_custom_command(TARGET GEMiniRecomp POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
        "${CMAKE_CURRENT_SOURCE_DIR}/game.toml"
        "$<TARGET_FILE_DIR:GEMiniRecomp>/game.toml")

if(WIN32 AND EXISTS "${GEMINI_BIOS_PATH}")
    add_custom_command(TARGET GEMiniRecomp POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different
            "${GEMINI_BIOS_PATH}"
            "$<TARGET_FILE_DIR:GEMiniRecomp>/gba_bios.bin")
endif()
