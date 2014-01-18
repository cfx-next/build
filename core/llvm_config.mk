# Support setting TARGET_CFX_CLANG_PREFIX to a custom directory for your build
ifeq ($(strip $(TARGET_CFX_CLANG_PREFIX)),)
  TARGET_CFX_CLANG_ROOT := prebuilts/clang/$(HOST_OS)-$(HOST_ARCH)/$(TARGET_CFX_CLANG_VERSION)
  TARGET_CFX_CLANG_PREFIX := $(TARGET_CFX_CLANG_ROOT)/bin
endif

CLANG := $(HOST_OUT_EXECUTABLES)/clang$(HOST_EXECUTABLE_SUFFIX)
CLANG_CXX := $(HOST_OUT_EXECUTABLES)/clang++$(HOST_EXECUTABLE_SUFFIX)
LLVM_AS := $(HOST_OUT_EXECUTABLES)/llvm-as$(HOST_EXECUTABLE_SUFFIX)
LLVM_LINK := $(HOST_OUT_EXECUTABLES)/llvm-link$(HOST_EXECUTABLE_SUFFIX)

CFX_CLANG := $(TARGET_CFX_CLANG_PREFIX)/clang
CFX_CLANG_CXX := $(TARGET_CFX_CLANG_PREFIX)/clang++
CFX_LLVM_AS := $(TARGET_CFX_CLANG_PREFIX)/llvm-as
CFX_LLVM_LINK := $(TARGET_CFX_CLANG_PREFIX)/llvm-link

define do-clang-flags-subst
  TARGET_GLOBAL_CLANG_FLAGS := $(subst $(1),$(2),$(TARGET_GLOBAL_CLANG_FLAGS))
  HOST_GLOBAL_CLANG_FLAGS := $(subst $(1),$(2),$(HOST_GLOBAL_CLANG_FLAGS))
endef

define clang-flags-subst
  $(eval $(call do-clang-flags-subst,$(1),$(2)))
endef


CLANG_CONFIG_EXTRA_CFLAGS := \
  -O3 \
  -D__compiler_offsetof=__builtin_offsetof

CFX_CLANG_CONFIG_EXTRA_CFLAGS := \
  $(CLANG_CONFIG_EXTRA_CFLAGS) \
  -Wno-error=extern-c-compat \
  -Wno-error=memsize-comparison \
  -fcolor-diagnostics \
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
  -march=armv7-a \
  -march=armv7-a-neon \
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

ifeq ($(TARGET_ARCH),aarch64)
  RS_TRIPLE := aarch64-none-linux-gnu
  CLANG_CONFIG_EXTRA_ASFLAGS += \
    -target aarch64-linux-gnu \
    -nostdlibinc \
    -B$(TARGET_TOOLCHAIN_ROOT)/aarch64-linux-android/bin
  CFX_CLANG_CONFIG_EXTRA_CFLAGS += \
    $(CLANG_CONFIG_EXTRA_ASFLAGS) \
    -fPIC \
    -mfloat-abi=softfp \
    -fno-short-enums \
    -D__ANDROID__ \
    -mllvm -arm-enable-ehabi \
    -arm-enable-ehabi-descriptors 
  CLANG_CONFIG_EXTRA_CFLAGS += \
    $(CLANG_CONFIG_EXTRA_ASFLAGS) \
    -mllvm -arm-enable-ehabi
  CLANG_CONFIG_EXTRA_LDFLAGS += \
    -target aarch64-linux-gnu \
    -B$(TARGET_TOOLCHAIN_ROOT)/aarch64-linux-android/bin
  CLANG_CONFIG_UNKNOWN_CFLAGS += \
    -mthumb-interwork \
    -fgcse-after-reload \
    -frerun-cse-after-loop \
    -frename-registers \
    -fno-builtin-sin \
    -fno-strict-volatile-bitfields \
    -fno-align-jumps \
    -Wa,--noexecstack
endif

ifeq ($(TARGET_ARCH),arm)
  RS_TRIPLE := armv7-none-linux-gnueabi
  CLANG_CONFIG_EXTRA_ASFLAGS += \
    -target arm-linux-androideabi \
    -nostdlibinc \
    -no-integrated-as \
    -B$(TARGET_TOOLCHAIN_ROOT)/arm-linux-androideabi/bin
  CFX_CLANG_CONFIG_EXTRA_CFLAGS += \
    $(CLANG_CONFIG_EXTRA_ASFLAGS) \
    -fPIC \
    -mfloat-abi=softfp \
    -fno-short-enums \
    -D__ARM_FEATURE_DSP=1 \
    -mllvm -arm-enable-ehabi \
    -arm-enable-ehabi-descriptors 
  CLANG_CONFIG_EXTRA_CFLAGS += \
    $(CLANG_CONFIG_EXTRA_ASFLAGS) \
    -mllvm -arm-enable-ehabi
  CLANG_CONFIG_EXTRA_LDFLAGS += \
    -target arm-linux-androideabi \
    -B$(TARGET_TOOLCHAIN_ROOT)/arm-linux-androideabi/bin
  CLANG_CONFIG_UNKNOWN_CFLAGS += \
    -mthumb-interwork \
    -fgcse-after-reload \
    -frerun-cse-after-loop \
    -frename-registers \
    -fno-builtin-sin \
    -fno-strict-volatile-bitfields \
    -fno-align-jumps \
    -Wa,--noexecstack
endif
ifeq ($(TARGET_ARCH),mips)
  RS_TRIPLE := mipsel-unknown-linux
  CLANG_CONFIG_EXTRA_ASFLAGS += \
    -target mipsel-linux-androideabi \
    -nostdlibinc \
    -B$(TARGET_TOOLCHAIN_ROOT)/mipsel-linux-android/bin
  CLANG_CONFIG_EXTRA_CFLAGS += $(CLANG_CONFIG_EXTRA_ASFLAGS)
  CLANG_CONFIG_EXTRA_LDFLAGS += \
    -target mipsel-linux-androideabi \
    -B$(TARGET_TOOLCHAIN_ROOT)/mipsel-linux-android/bin
  CLANG_CONFIG_UNKNOWN_CFLAGS += \
    -EL \
    -mips32 \
    -mips32r2 \
    -mhard-float \
    -fno-strict-volatile-bitfields \
    -fgcse-after-reload \
    -frerun-cse-after-loop \
    -frename-registers \
    -march=mips32r2 \
    -mtune=mips32r2 \
    -march=mips32 \
    -mtune=mips32 \
    -msynci \
    -mno-fused-madd
endif
ifeq ($(TARGET_ARCH),x86)
  RS_TRIPLE := i686-unknown-linux
  CLANG_CONFIG_EXTRA_ASFLAGS += \
    -target i686-linux-android \
    -msse3 \
    -nostdlibinc \
    -B$(TARGET_TOOLCHAIN_ROOT)/x86_64-linux-android/bin
  CLANG_CONFIG_EXTRA_CFLAGS += $(CLANG_CONFIG_EXTRA_ASFLAGS)
  CLANG_CONFIG_EXTRA_LDFLAGS += \
    -target i686-linux-android \
    -B$(TARGET_TOOLCHAIN_ROOT)/x86_64-linux-android/bin
  CLANG_CONFIG_UNKNOWN_CFLAGS += \
    -finline-limit=300 \
    -fno-inline-functions-called-once \
    -mfpmath=sse \
    -mbionic
endif
ifeq ($(TARGET_ARCH),x86_64)
  RS_TRIPLE := x86_64-unknown-linux
  CLANG_CONFIG_EXTRA_ASFLAGS += \
    -target x86_64-linux-android \
    -nostdlibinc \
    -B$(TARGET_TOOLCHAIN_ROOT)/x86_64-linux-android/bin
  CLANG_CONFIG_EXTRA_CFLAGS += $(CLANG_CONFIG_EXTRA_ASFLAGS)
  CLANG_CONFIG_EXTRA_LDFLAGS += \
    -target x86_64-linux-android \
    -B$(TARGET_TOOLCHAIN_ROOT)/x86_64-linux-android/bin
  CLANG_CONFIG_UNKNOWN_CFLAGS += \
    -finline-limit=300 \
    -fno-inline-functions-called-once \
    -mfpmath=sse \
    -mbionic
endif


CLANG_CONFIG_EXTRA_TARGET_C_INCLUDES := external/clang/lib/include $(TARGET_OUT_HEADERS)/clang
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

ADDRESS_SANITIZER_CONFIG_EXTRA_CFLAGS := -fsanitize=address
ADDRESS_SANITIZER_CONFIG_EXTRA_LDFLAGS := -Wl,-u,__asan_preinit
ADDRESS_SANITIZER_CONFIG_EXTRA_SHARED_LIBRARIES := libdl libasan_preload
ADDRESS_SANITIZER_CONFIG_EXTRA_STATIC_LIBRARIES := libasan

# This allows us to use the superset of functionality that compiler-rt
# provides to Clang (for supporting features like -ftrapv).
COMPILER_RT_CONFIG_EXTRA_STATIC_LIBRARIES := libcompiler_rt-extras
