# Target-specific configuration

# Enable DirectTrack on QCOM legacy boards
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    TARGET_QCOM_FLAGS += -DQCOM_HARDWARE
    ifeq ($(TARGET_USES_QCOM_BSP),true)
        TARGET_QCOM_FLAGS += -DQCOM_BSP
    endif
    # Enable DirectTrack for legacy targets
    ifneq ($(filter caf bfam,$(TARGET_QCOM_AUDIO_VARIANT)),)
        ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
            TARGET_QCOM_FLAGS += -DQCOM_DIRECTTRACK
            TARGET_QCOM_FLAGS += -DQCOM_DIRECTTRACK
        endif
    endif
endif
