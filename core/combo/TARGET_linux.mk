#
# Copyright (C) 2006 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Common configuration for Linux on ARM, MIPS, and X86.
# Included by combo/TARGET_linux-arm.mk, combo/TARGET_linux-mips.mk,
# and TARGET_linux-x86.mk

ifeq ($(strip $(TARGET_GCC_VERSION_EXP)),)
  TARGET_GCC_VERSION := 4.8
else
  TARGET_GCC_VERSION := $(TARGET_GCC_VERSION_EXP)
endif

# Include the arch-variant-specific configuration file.
# Its role is to define various ARCH_X86_HAVE_XXX feature macros,
# plus initial values for TARGET_GLOBAL_CFLAGS
#
TARGET_ARCH_SPECIFIC_MAKEFILE := $(BUILD_COMBOS)/arch/$(TARGET_ARCH)/$(TARGET_ARCH_VARIANT).mk
ifeq ($(strip $(wildcard $(TARGET_ARCH_SPECIFIC_MAKEFILE))),)
  $(error Unknown $(TARGET_ARCH) architecture variant: $(TARGET_ARCH_VARIANT))
endif

include $(TARGET_ARCH_SPECIFIC_MAKEFILE)

TARGET_CC := $(TARGET_TOOLS_PREFIX)gcc$(HOST_EXECUTABLE_SUFFIX)
TARGET_CXX := $(TARGET_TOOLS_PREFIX)g++$(HOST_EXECUTABLE_SUFFIX)
TARGET_AR := $(TARGET_TOOLS_PREFIX)ar$(HOST_EXECUTABLE_SUFFIX)
TARGET_OBJCOPY := $(TARGET_TOOLS_PREFIX)objcopy$(HOST_EXECUTABLE_SUFFIX)
TARGET_LD := $(TARGET_TOOLS_PREFIX)ld$(HOST_EXECUTABLE_SUFFIX)
TARGET_STRIP := $(TARGET_TOOLS_PREFIX)strip$(HOST_EXECUTABLE_SUFFIX)

libc_root := bionic/libc
libm_root := bionic/libm
libstdc++_root := bionic/libstdc++
libthread_db_root := bionic/libthread_db

# Set FORCE_TARGET_DEBUGGING to "true" in your buildspec.mk
# or in your environment to gdb debugging easier.
# Don't forget to do a clean build.
ifeq ($(FORCE_TARGET_DEBUGGING),true)
  TARGET_GLOBAL_CFLAGS += -fno-omit-frame-pointer \
                          -fno-strict-aliasing
endif

## on some hosts, the target cross-compiler is not available so do not run this command
ifneq ($(wildcard $(TARGET_CC)),)
  # We compile with the global cflags to ensure that
  # any flags which affect libgcc are correctly taken
  # into account.
  TARGET_LIBGCC := $(shell $(TARGET_CC) $(TARGET_GLOBAL_CFLAGS) -print-libgcc-file-name)
  target_libgcov := $(shell $(TARGET_CC) $(TARGET_GLOBAL_CFLAGS) \
                    -print-file-name=libgcov.a)
endif

no_debug_variant := $(filter user codefirex,$(TARGET_BUILD_VARIANT))
ifneq (,$(no_debug_variant))
  TARGET_STRIP_COMMAND = $(TARGET_STRIP) --strip-debug $< -o $@
else
  TARGET_STRIP_COMMAND = $(TARGET_STRIP) --strip-debug $< -o $@ && \
                         $(TARGET_OBJCOPY) --add-gnu-debuglink=$< $@
endif

TARGET_NO_UNDEFINED_LDFLAGS := -Wl,--no-undefined

# unless CUSTOM_KERNEL_HEADERS is defined, we're going to use
# symlinks located in out/ to point to the appropriate kernel
# headers. see 'config/kernel_headers.make' for more details
#
ifneq ($(CUSTOM_KERNEL_HEADERS),)
  KERNEL_HEADERS_COMMON := $(CUSTOM_KERNEL_HEADERS)
  KERNEL_HEADERS_ARCH   := $(CUSTOM_KERNEL_HEADERS)
else
  KERNEL_HEADERS_COMMON := $(libc_root)/kernel/common
  KERNEL_HEADERS_ARCH   := $(libc_root)/kernel/arch-$(TARGET_ARCH)
endif
KERNEL_HEADERS := $(KERNEL_HEADERS_COMMON) $(KERNEL_HEADERS_ARCH)

# Define LTO (Link Time Optimization options

ifneq ($(strip $(DISABLE_BUILD_LTO)),)
  # Disable global LTO if DISABLE_BUILD_LTO is set.
  TARGET_LTO_CFLAGS := -flto \
                       -fno-toplevel-reorder
endif

# Define FDO (Feedback Directed Optimization) options.

TARGET_FDO_CFLAGS:=
TARGET_FDO_LIB:=

ifneq ($(strip $(BUILD_FDO_INSTRUMENT)),)
  # Set BUILD_FDO_INSTRUMENT to turn on FDO instrumentation.
  # The profile will be generated on /data/local/tmp/profile on the device.
  TARGET_FDO_CFLAGS := -fprofile-generate=/data/local/tmp/profile -DANDROID_FDO
  TARGET_FDO_LIB := $(target_libgcov)
else
  # Disable FDO optimizations if PREFER_BUILD_AUTO_FDO is set to enable Auto FDO
  # optimizations.
  ifeq ($(strip $(BUILD_PREFER_AUTO_FDO)),)
    # If BUILD_FDO_INSTRUMENT is turned off, then consider doing the FDO optimizations.
    # Set TARGET_FDO_PROFILE_PATH to set a custom profile directory for your build.
    ifeq ($(strip $(TARGET_FDO_PROFILE_PATH)),)
      TARGET_FDO_PROFILE_PATH := fdo/profiles/$(TARGET_ARCH)/$(TARGET_ARCH_VARIANT)
    else
      ifeq ($(strip $(wildcard $(TARGET_FDO_PROFILE_PATH))),)
        $(warning Custom TARGET_FDO_PROFILE_PATH supplied, but directory does not exist. Turn off auto FDO.)
      endif
    endif

    # If the FDO profile directory can't be found, then FDO is off.
    ifneq ($(strip $(wildcard $(TARGET_FDO_PROFILE_PATH))),)
      TARGET_FDO_CFLAGS := -fprofile-use=$(TARGET_FDO_PROFILE_PATH) -DANDROID_FDO
      TARGET_FDO_LIB := $(target_libgcov)
    endif
  endif
endif

# Define AFDO (Auto Feedback Directed Optimization) options.
ifneq ($(strip $(BUILD_PREFER_AUTO_FDO)),)
  # Set BUILD_PREFER_AUTO_FDO to prefer Auto FDO optimizations over FDO optimizations.
  ifeq ($(strip $(BUILD_FDO_INSTRUMENT)),)
    # Do not enable auto FDO optimizations if FDO profile instrumentation is enabled.
    TARGET_AUTO_FDO_CFLAGS:=
    TARGET_AUTO_FDO_LIB:=

    # If BUILD_FDO_INSTRUMENT is turned off, then consider doing the auto FDO optimizations.
    # Set TARGET_AUTO_FDO_PROFILE_PATH to set a custom profile directory for your build.
    #
    # In the case of TARGET_FDO_PROFILE_PATH existing but not TARGET_AUTO_FDO_PROFILE_PATH,
    # set TARGET_FDO_PROFILE_PATH as TARGET_AUTO_FDO_PROFILE_PATH.
    ifeq ($(strip $(TARGET_AUTO_FDO_PROFILE_PATH)),)
      ifneq ($(strip $(TARGET_FDO_PROFILE_PATH)),)
         TARGET_AUTO_FDO_PROFILE_PATH := $(TARGET_FDO_PROFILE_PATH)
      endif
    endif

    # Necessary duplication due to the possibility of the above profile path case existing.
    ifeq ($(strip $(TARGET_AUTO_FDO_PROFILE_PATH)),)
      TARGET_AUTO_FDO_PROFILE_PATH := afdo/profiles/$(TARGET_ARCH)/$(TARGET_ARCH_VARIANT)
    else
      ifeq ($(strip $(wildcard $(TARGET_AUTO_FDO_PROFILE_PATH))),)
        $(warning Custom TARGET_AUTO_FDO_PROFILE_PATH supplied, but directory does not exist. Turn off FDO.)
      endif
    endif

    # If the auto FDO profile directory can't be found, then auto FDO is off.
    ifneq ($(strip $(wildcard $(TARGET_AUTO_FDO_PROFILE_PATH))),)
      # Inline early to assist in auto FDO performance unless
      # BUILD_DISABLE_AUTO_FDO_EARLY_INLINING exists in the environment.
      ifeq ($(strip $(BUILD_DISABLE_AUTO_FDO_EARLY_INLINING)),)
        TARGET_AUTO_FDO_CFLAGS += -fearly-inlining
      endif
      TARGET_AUTO_FDO_CFLAGS += -fprofile-use=$(TARGET_AUTO_FDO_PROFILE_PATH) -DANDROID_FDO
      TARGET_AUTO_FDO_LIB := $(target_libgcov)
    endif
  endif
endif

TARGET_DEFAULT_SYSTEM_SHARED_LIBRARIES := libc libstdc++ libm

TARGET_CRTBEGIN_STATIC_O := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/crtbegin_static.o
TARGET_CRTBEGIN_DYNAMIC_O := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/crtbegin_dynamic.o
TARGET_CRTEND_O := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/crtend_android.o
TARGET_CRTBEGIN_SO_O := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/crtbegin_so.o
TARGET_CRTEND_SO_O := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/crtend_so.o

TARGET_STRIP_MODULE := true
TARGET_CUSTOM_LD_COMMAND := true

#
# This is intended to set cfx specific compiler flags
# for some difficult devices so that we may otherwise
# globally keep the all optimizations globally enabled
#

# Only set -O3 for thumb cflags if explicitly specified
ifeq ($(ARCH_ARM_HIGH_OPTIMIZATION),true)
  TARGET_thumb_CFLAGS += -O3
else
  TARGET_thumb_CFLAGS += -Os
endif

# A clean way of only disabling a few optimizations that
# cause problems on devices such as Grouper
ifeq ($(ARCH_ARM_HIGH_OPTIMIZATION_COMPAT),true)
  TARGET_CFX_CFLAGS +=    -fno-tree-vectorize
endif

# Use -O2 for TARGET_arm_CFLAGS for the following devices due to
# "problem" modules until they're discovered
ifneq ($(filter m7att m7spr m7tmo m7wls,$(PRODUCT_DEVICE)),)
  TARGET_arm_CFLAGS += -O2
else
  ifeq ($(TARGET_BUILD_SMALL_SYSTEM),true)
    TARGET_arm_CFLAGS += -O2
  else
    TARGET_arm_CFLAGS += -O3
  endif
endif

# Enhance future LIPO support by recording non-mergeable compiler
# optimizations in a .gnu.switches.text section if
# BUILD_RECORD_COMPILATION_INFO_IN_ELF is set
ifneq ($(strip $(BUILD_RECORD_COMPILATION_INFO_IN_ELF)),)
  TARGET_CFX_CFLAGS += -frecord-compilation-info-in-elf
endif

ifeq ($(TARGET_QCOM_DISPLAY_VARIANT),legacy)
  TARGET_CFX_CFLAGS += -DLEGACY_QCOM_VARIANT
endif

ifeq ($(TARGET_QCOM_DISPLAY_VARIANT),caf)
  TARGET_CFX_CFLAGS += -DCAF_QCOM_VARIANT
endif
