# set minimum required version of cmake to avoid errors
cmake_minimum_required(VERSION 3.22)

# to make sure CMake knows that the target will not be executed on this machine
set(CMAKE_SYSTEM_NAME Generic)

# set C && Cpp versions
set(CMAKE_C_STANDARD 99)

# project name + defining used languages 
project(RPI3B_BONUS_TASK C ASM)

# defining system architecture
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# setting compiler, assembler, linker, and objcopy
set(CMAKE_C_COMPILER aarch64-rpi3b-elf-gcc)
set(CMAKE_ASM_COMPILER aarch64-rpi3b-elf-as)
set(CMAKE_LINKER aarch64-rpi3b-elf-ld)
set(CMAKE_OBJCOPY aarch64-rpi3b-elf-objcopy)

# collect all .c files
file(GLOB_RECURSE ${PROJECT_NAME}_SRC_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c)

# collect all .s files
file(GLOB_RECURSE ${PROJECT_NAME}_ASM_FILES ${CMAKE_CURRENT_SOURCE_DIR}/asm/*.s)

# collect linker script
file(GLOB_RECURSE ${PROJECT_NAME}_LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/ld/*.ld)

# passing linker script to linker
add_compile_options("-T ${LINKER_SCRIPT}")

# compiling and getting .elf file
add_executable(${PROJECT_NAME}.elf "${${PROJECT_NAME}_SRC_FILES}" "${PROJECT_NAME}_ASM_FILES") # main target

# adding dir where required .h file is located
target_include_directories(${PROJECT_NAME}.elf PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/inc/")

# defining custom objcopy command to generate .bin file
add_custom_target(get_bin
    DEPENDS "${PROJECT_NAME}.elf"
    COMMAND "${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin"
    VERBATIM
    COMMENT "Generating binary file: ${PROJECT_NAME}.bin"
)
