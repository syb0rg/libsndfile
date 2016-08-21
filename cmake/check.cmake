include (CheckFunctionExists)
include (CheckIncludeFile)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckTypeSize)
include (TestBigEndian)

if (WIN32)
    set(TYPEOF_SF_COUNT_T __int64)
else (UNIX)
    set(TYPEOF_SF_COUNT_T int64_t)
endif ()
set(SF_COUNT_MAX 0x7fffffffffffffffll)

find_package (ALSA)
if (ALSA_FOUND)
    set (HAVE_ALSA_ASOUNDLIB_H TRUE)
else ()
    find_package (Sndio)
    set (HAVE_SNDIO_H ${SNDIO_FOUND})
endif (ALSA_FOUND)

check_include_file(byteswap.h       HAVE_BYTESWAP_H)
check_include_file(dlfcn.h          HAVE_DLFCN_H)
check_include_file(endian.h         HAVE_ENDIAN_H)
check_include_file(inttypes.h       HAVE_INTTYPES_H)
check_include_file(locale.h         HAVE_LOCALE_H)
check_include_file(memory.h         HAVE_MEMORY_H)
check_include_file(stdint.h         HAVE_STDINT_H)
check_include_file(stdlib.h         HAVE_STDLIB_H)
check_include_file(string.h         HAVE_STRING_H)
check_include_file(strings.h        HAVE_STRINGS_H)
check_include_file(sys/stat.h       HAVE_SYS_STAT_H)
check_include_file(sys/time.h		HAVE_SYS_TIME_H)
check_include_file(sys/types.h      HAVE_SYS_TYPES_H)
check_include_file(sys/wait.h       HAVE_SYS_WAIT_H)
check_include_file(unistd.h         HAVE_UNISTD_H)
check_type_size(int64_t                 SIZEOF_INT64_T)
check_type_size(double                  SIZEOF_DOUBLE)
check_type_size(float                   SIZEOF_FLOAT)
check_type_size(int                     SIZEOF_INT)
check_type_size(loff_t                  SIZEOF_LOFF_T)
check_type_size(long                    SIZEOF_LONG)
check_type_size(long\ long              SIZEOF_LONG_LONG)
check_type_size(offt64_t                SIZEOF_OFF64_T)
check_type_size(off_t                   SIZEOF_OFF_T)
check_type_size(short                   SIZEOF_SHORT)
check_type_size(size_t                  SIZEOF_SIZE_T)
check_type_size(ssize_t                 SIZEOF_SSIZE_T)
check_type_size(void*                   SIZEOF_VOIDP)
check_type_size(wchar_t                 SIZEOF_WCHAR_T)

if (WIN32)
set (TYPEOF_SF_COUNT_T "__int64")
set (SF_COUNT_MAX "0x7FFFFFFFFFFFFFFFLL")
set (SIZEOF_SF_COUNT_T 8)
else ()

if ((SIZEOF_OFF_T EQUAL 8) OR (SIZEOF_LOFF_T EQUAL 8) OR (SIZEOF_OFF64_T EQUAL 8))
set (TYPEOF_SF_COUNT_T "int64_t")
set (SF_COUNT_MAX "0x7FFFFFFFFFFFFFFFLL")
set (SIZEOF_SF_COUNT_T 8)
else ()
# TODO: Check 64-bit support
endif ()

# Fallback to long
if (NOT TYPEOF_SF_COUNT_T)
set (TYPEOF_SF_COUNT_T "long")
set (SF_COUNT_MAX "0x7FFFFFFF")
set (SIZEOF_SF_COUNT_T 4)
endif ()

check_type_size(${TYPEOF_SF_COUNT_T} SIZEOF_SF_COUNT_T)

endif ()

find_library (M_LIBRARY m)
# M is found
if (M_LIBRARY)
# Check if he need to link 'm' for math functions
check_library_exists (m floor "" LIBM_REQUIRED)
if (LIBM_REQUIRED)
list (APPEND CMAKE_REQUIRED_LIBRARIES ${M_LIBRARY})
# We don't to link 'm', clean up
else ()
unset (M_LIBRARY)
endif ()
endif ()

check_library_exists (sqlite3 sqlite3_close "" HAVE_SQLITE3)

check_function_exists(calloc		HAVE_CALLOC)
check_function_exists(free		HAVE_FREE)
check_function_exists(fstat     	HAVE_FSTAT)
check_function_exists(fstat64		HAVE_FSTAT64)
check_function_exists(fsync    		HAVE_FSYNC)
check_function_exists(ftruncate		HAVE_FTRUNCATE)
check_function_exists(getpagesize	HAVE_GETPAGESIZE)
check_function_exists(gettimeofday	HAVE_GETTIMEOFDAY)
check_function_exists(gmtime		HAVE_GMTIME)
check_function_exists(gmtime_r		HAVE_GMTIME_R)
check_function_exists(localtime		HAVE_LOCALTIME)
check_function_exists(localtime_r	HAVE_LOCALTIME_R)
check_function_exists(lseek      	HAVE_LSEEK)
check_function_exists(lseek64		HAVE_LSEEK64)
check_function_exists(malloc		HAVE_MALLOC)
check_function_exists(mmap		HAVE_MMAP)
check_function_exists(open		HAVE_OPEN)
check_function_exists(pipe		HAVE_PIPE)
check_function_exists(read		HAVE_READ)
check_function_exists(realloc		HAVE_REALLOC)
check_function_exists(setlocale     	HAVE_SETLOCALE)
check_function_exists(snprintf		HAVE_SNPRINTF)
check_function_exists(vsnprintf     	HAVE_VSNPRINTF)
check_function_exists(waitpid		HAVE_WAITPID)
check_function_exists(write         	HAVE_WRITE)
check_function_exists(ceil          	HAVE_CEIL)
check_function_exists(floor         	HAVE_FLOOR)
check_function_exists(fmod          	HAVE_FMOD)
check_function_exists(lrint         	HAVE_LRINT)
check_function_exists(lrintf        	HAVE_LRINTF)
check_function_exists(lround        	HAVE_LROUND)

check_symbol_exists (S_IRGRP sys/stat.h HAVE_DECL_S_IRGRP)

test_big_endian(WORDS_BIGENDIAN)
if (WORDS_BIGENDIAN)
	set (WORDS_BIGENDIAN 1)
	set (CPU_IS_BIG_ENDIAN 1)
else (${LITTLE_ENDIAN})
	set (CPU_IS_LITTLE_ENDIAN 1)
endif ()

if (WIN32)
	set (OS_IS_WIN32 1)
	set (USE_WINDOWS_API 1)
	set (WIN32_TARGET_DLL 1)
if (MINGW)
	set (__USE_MINGW_ANSI_STDIO 1)
endif (MINGW)
endif (WIN32)

if (${CMAKE_SYSTEM_NAME} STREQUAL "OpenBSD")
	set (OS_IS_OPENBSD 1)
else ()
	set (OS_IS_OPENBSD 0)
endif ()


if (CMAKE_COMPILER_IS_GNUCC OR (CMAKE_C_COMPILER_ID MATCHES "Clang"))
	set (COMPILER_IS_GCC 1)
	set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra" CACHE STRING "" FORCE)
	set (CMAKE_CXX__FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra" CACHE STRING "" FORCE)
endif ()
