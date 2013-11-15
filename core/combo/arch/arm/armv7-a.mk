# Configuration for Linux on ARM.
# Generating binaries for the ARMv7-a architecture and higher
#
ARCH_ARM_HAVE_ARMV7A            := true
ARCH_ARM_HAVE_VFP               := true

# Note: Hard coding the 'tune' value here is probably not ideal,
# and a better solution should be found in the future.
#
arch_variant_cflags := \
    -mfloat-abi=softfp \
    -mfpu=vfpv3-d16

ifeq ($(filter cortex-a7 cortex-a15, $(TARGET_CPU_VARIANT)),)
  arch_variant_cflags += -march=armv7-a
endif

arch_variant_ldflags := \
        -Wl,--fix-cortex-a8

# Neither "krait" or "generic" are valid -mcpu values.
# Set a valid alternative for krait, and leave generic
# without an argument.
ifeq ($(filter generic krait, $(TARGET_CPU_VARIANT)),)
  arch_variant_cflags += -mcpu=$(TARGET_CPU_VARIANT)
else
  ifeq ($(TARGET_CPU_VARIANT), krait)
    arch_variant_cflags += -mcpu=cortex-a9
  endif
endif

