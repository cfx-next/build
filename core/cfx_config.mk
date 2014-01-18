#
# Copyright (C) 2013 The Android Open Source Project
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

# Configuration for cfx configuration
# Included by combo/combo/TARGET_$(TARGET_ARCH).mk

# Define LTO (Link Time Optimization) options

ifneq ($(strip $(DISABLE_BUILD_LTO)),)
  # Disable global LTO if DISABLE_BUILD_LTO is set
  TARGET_LTO_CFLAGS := -flto \
                       -fno-toplevel-reorder
endif

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

ifneq ($(HOST_OS),darwin)
  TARGET_CFX_LDFLAGS += -Wl,-O3
endif
