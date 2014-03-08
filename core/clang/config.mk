ifeq (true,$(FORCE_BUILD_LLVM_COMPONENTS))
LLVM_PREBUILTS_PATH := $(BUILD_OUT_EXECUTABLES)
LLVM_PREBUILTS_HEADER_PATH := external/clang/lib/include
else
LLVM_PREBUILTS_PATH := prebuilts/clang/$(BUILD_OS)-x86/host/3.4/bin
LLVM_PREBUILTS_HEADER_PATH := prebuilts/clang/$(BUILD_OS)-x86/host/3.4/lib/clang/3.4/include/
endif

# Support setting TARGET_CFX_CLANG_PREFIX to a custom directory for your build
ifeq ($(strip $(TARGET_CFX_CLANG_PREFIX)),)
  TARGET_CFX_CLANG_ROOT := prebuilts/clang/$(HOST_OS)-$(HOST_ARCH)/$(TARGET_CFX_CLANG_VERSION)
  TARGET_CFX_CLANG_PREFIX := $(TARGET_CFX_CLANG_ROOT)/bin
endif

CLANG := $(LLVM_PREBUILTS_PATH)/clang$(BUILD_EXECUTABLE_SUFFIX)
CLANG_CXX := $(LLVM_PREBUILTS_PATH)/clang++$(BUILD_EXECUTABLE_SUFFIX)
CLANG_TBLGEN := $(LLVM_PREBUILTS_PATH)/clang-tblgen$(BUILD_EXECUTABLE_SUFFIX)
LLVM_AS := $(LLVM_PREBUILTS_PATH)/llvm-as$(BUILD_EXECUTABLE_SUFFIX)
LLVM_LINK := $(LLVM_PREBUILTS_PATH)/llvm-link$(BUILD_EXECUTABLE_SUFFIX)
TBLGEN := $(LLVM_PREBUILTS_PATH)/tblgen$(BUILD_EXECUTABLE_SUFFIX)

CFX_CLANG := $(TARGET_CFX_CLANG_PREFIX)/clang
CFX_CLANG_CXX := $(TARGET_CFX_CLANG_PREFIX)/clang++
CFX_LLVM_AS := $(TARGET_CFX_CLANG_PREFIX)/llvm-as
CFX_LLVM_LINK := $(TARGET_CFX_CLANG_PREFIX)/llvm-link

# Clang flags for all host or target rules
CLANG_CONFIG_EXTRA_ASFLAGS :=
CLANG_CONFIG_EXTRA_CFLAGS :=
CLANG_CONFIG_EXTRA_CPPFLAGS :=
CLANG_CONFIG_EXTRA_LDFLAGS :=

CLANG_CONFIG_EXTRA_CFLAGS := \
  -D__compiler_offsetof=__builtin_offsetof

CFX_CLANG_CONFIG_EXTRA_CFLAGS += \
  $(CLANG_CONFIG_EXTRA_CFLAGS) \
  -Wno-error=c++11-narrowing \
  -Wno-error=extern-c-compat \
  -Wno-error=implicit-exception-spec-mismatch \
  -Wno-error=memsize-comparison \
  -fcolor-diagnostics \
  -D__ANDROID__ \
  -Qignore-c-std-not-allowed-with-cplusplus

CLANG_CONFIG_UNKNOWN_CFLAGS := \
  -fipa-cp-clone \
  -finline-limit=64 \
  -foptimize-sincos \
  -fpredictive-commoning \
  -fsched-spec-load \
  -ftree-loop-distribution \
  -ftree-loop-linear \
  -funswitch-loops \
  -fvect-cost-model \
  -mvectorize-with-neon-quad \
  -Wstrict-aliasing=3 \
  -Wno-unused-but-set-parameter \
  -fno-if-conversion \
  -fno-inline-functions-called-once \
  -fvect-cost-model=dynamic \
  -ftree-loop-distribution \
  -ftree-loop-linear \
  -fpredictive-commoning \
  -fstrict-volatile-bitfields \
  -fno-align-jumps \
  -Wno-psabi

# Clang flags for all host rules
CLANG_CONFIG_HOST_EXTRA_ASFLAGS :=
CLANG_CONFIG_HOST_EXTRA_CFLAGS :=
CLANG_CONFIG_HOST_EXTRA_CPPFLAGS :=
CLANG_CONFIG_HOST_EXTRA_LDFLAGS :=

# Clang flags for all target rules
CLANG_CONFIG_TARGET_EXTRA_ASFLAGS :=
CLANG_CONFIG_TARGET_EXTRA_CFLAGS := -nostdlibinc
CLANG_CONFIG_TARGET_EXTRA_CPPFLAGS := -nostdlibinc
CLANG_CONFIG_TARGET_EXTRA_LDFLAGS :=

# HOST config
include $(BUILD_SYSTEM)/clang/HOST_$(HOST_ARCH).mk

# TARGET config
clang_2nd_arch_prefix :=
include $(BUILD_SYSTEM)/clang/TARGET_$(TARGET_ARCH).mk

# TARGET_2ND_ARCH config
ifdef TARGET_2ND_ARCH
clang_2nd_arch_prefix := $(TARGET_2ND_ARCH_VAR_PREFIX)
include $(BUILD_SYSTEM)/clang/TARGET_$(TARGET_2ND_ARCH).mk
endif


# Clang compiler-specific libc headers
CLANG_CONFIG_EXTRA_HOST_C_INCLUDES := $(LLVM_PREBUILTS_HEADER_PATH)
CLANG_CONFIG_EXTRA_TARGET_C_INCLUDES := $(LLVM_PREBUILTS_HEADER_PATH) $(TARGET_OUT_HEADERS)/clang

CFX_CLANG_CONFIG_EXTRA_TARGET_C_INCLUDES := $(TARGET_CFX_CLANG_ROOT)/lib/clang/$(TARGET_CFX_CLANG_VERSION)/include
# remove unknown flags to define CLANG_FLAGS
TARGET_GLOBAL_CLANG_FLAGS += $(filter-out $(CLANG_CONFIG_UNKNOWN_CFLAGS),$(TARGET_GLOBAL_CFLAGS))
HOST_GLOBAL_CLANG_FLAGS += $(filter-out $(CLANG_CONFIG_UNKNOWN_CFLAGS),$(HOST_GLOBAL_CFLAGS))

TARGET_arm_CLANG_CFLAGS += $(filter-out $(CLANG_CONFIG_UNKNOWN_CFLAGS),$(TARGET_arm_CFLAGS))
TARGET_thumb_CLANG_CFLAGS += $(filter-out $(CLANG_CONFIG_UNKNOWN_CFLAGS),$(TARGET_thumb_CFLAGS))

# llvm does not yet support -march=armv5e nor -march=armv5te, fall back to armv5 or armv5t
$(call clang-flags-subst,-march=armv5te,-march=armv5t)
$(call clang-flags-subst,-march=armv5e,-march=armv5)

# clang does not support -Wno-psabi, -Wno-unused-but-set-variable, and
# -Wno-unused-but-set-parameter
$(call clang-flags-subst,-Wno-psabi,)
$(call clang-flags-subst,-Wno-unused-but-set-variable,)
$(call clang-flags-subst,-Wno-unused-but-set-parameter,)

# clang does not support -mcpu=cortex-a15 yet - fall back to armv7-a for now
$(call clang-flags-subst,-mcpu=cortex-a15,-march=armv7-a)

# Address sanitizer clang config
ADDRESS_SANITIZER_CONFIG_EXTRA_CFLAGS := -fsanitize=address
ADDRESS_SANITIZER_CONFIG_EXTRA_LDFLAGS := -Wl,-u,__asan_preinit
ADDRESS_SANITIZER_CONFIG_EXTRA_SHARED_LIBRARIES := libdl libasan_preload
ADDRESS_SANITIZER_CONFIG_EXTRA_STATIC_LIBRARIES := libasan

# This allows us to use the superset of functionality that compiler-rt
# provides to Clang (for supporting features like -ftrapv).
COMPILER_RT_CONFIG_EXTRA_STATIC_LIBRARIES := libcompiler_rt-extras
