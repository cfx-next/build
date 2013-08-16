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

ifneq ($(TARGET_CPU_VARIANT), cortex-a15)
  arch_variant_cflags += -march=armv7-a
endif

arch_variant_ldflags := \
        -Wl,--fix-cortex-a8

#
# Cpu variant specific flags
#
ifeq ($(TARGET_CPU_VARIANT), cortex-a15)
  ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS     := true
  ARCH_ARM_NEON_MEMSET_DIVIDER            := 132
endif

ifeq ($(TARGET_CPU_VARIANT), krait)
  ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS     := true
  ARCH_ARM_NEON_MEMSET_DIVIDER            := 132
  ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER  := 224
  TARGET_USE_KRAIT_BIONIC_OPTIMIZATION    := true
  TARGET_USE_KRAIT_PLD_SET                := true
  TARGET_KRAIT_BIONIC_PLDOFFS             := 10
  TARGET_KRAIT_BIONIC_PLDTHRESH           := 10
  TARGET_KRAIT_BIONIC_BBTHRESH            := 64
  TARGET_KRAIT_BIONIC_PLDSIZE             := 64
endif

ifeq ($(TARGET_CPU_VARIANT), cortex-a9)
  ifeq ($(call is-vendor-board-platform,QCOM),true)
    TARGET_USE_SCORPION_BIONIC_OPTIMIZATION := true
    TARGET_USE_SCORPION_PLD_SET             := true
    TARGET_USE_SCORPION_PLD_SET             := true
    TARGET_SCORPION_BIONIC_PLDOFFS          := 6
    TARGET_SCORPION_BIONIC_PLDSIZE          := 128
  endif
  ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS     := true
  ARCH_ARM_NEON_MEMSET_DIVIDER            := 132
  ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER  := 224
endif

ifeq ($(TARGET_CPU_VARIANT), cortex-a8)
  ifeq ($(call is-vendor-board-platform,QCOM),true)
    TARGET_USE_SPARROW_BIONIC_OPTIMIZATION  := true
  endif
  ARCH_ARM_HAVE_NEON_UNALIGNED_ACCESS     := true
  ARCH_ARM_NEON_MEMSET_DIVIDER            := 132
  ARCH_ARM_NEON_MEMCPY_ALIGNMENT_DIVIDER  := 224
endif

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

