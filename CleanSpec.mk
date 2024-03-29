# Copyright (C) 2007 The Android Open Source Project
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

# If you don't need to do a full clean build but would like to touch
# a file or delete some intermediate files, add a clean step to the end
# of the list.  These steps will only be run once, if they haven't been
# run before.
#
# E.g.:
#     $(call add-clean-step, touch -c external/sqlite/sqlite3.h)
#     $(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES/libz_intermediates)
#
# Always use "touch -c" and "rm -f" or "rm -rf" to gracefully deal with
# files that are missing or have been moved.
#
# Use $(PRODUCT_OUT) to get to the "out/target/product/blah/" directory.
# Use $(OUT_DIR) to refer to the "out" directory.
#
# If you need to re-do something that's already mentioned, just copy
# the command and add it to the bottom of the list.  E.g., if a change
# that you made last week required touching a file and a change you
# made today requires touching the same file, just copy the old
# touch step and add it to the end of the list.
#
# ************************************************
# NEWER CLEAN STEPS MUST BE AT THE END OF THE LIST
# ************************************************

# For example:
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/APPS/AndroidTests_intermediates)
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/JAVA_LIBRARIES/core_intermediates)
#$(call add-clean-step, find $(OUT_DIR) -type f -name "IGTalkSession*" -print0 | xargs -0 rm -f)
#$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/*)

$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/APPS)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libmediaplayerservice_intermediates)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libmedia_jni_intermediates)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libstagefright_omx_intermediates)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/root/default.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/recovery/root/default.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/vendor)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/android-info.txt)
$(call add-clean-step, find $(PRODUCT_OUT) -name "*.apk" | xargs rm)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/*/LINKED)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/lib/*.so)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/lib/*.so)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/symbols/system/lib/*.so)
$(call add-clean-step, rm -rf $(HOST_OUT_EXECUTABLES)/iself)
$(call add-clean-step, rm -rf $(HOST_OUT_EXECUTABLES)/lsd)
$(call add-clean-step, rm -rf $(HOST_OUT_EXECUTABLES)/apriori)
$(call add-clean-step, rm -rf $(HOST_OUT_EXECUTABLES)/isprelinked)
$(call add-clean-step, rm -rf $(HOST_OUT_EXECUTABLES)/soslim)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/lib/*.so)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/lib/*.so)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/symbols/system/lib/*.so)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/YouTube*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libstagefright_intermediates)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libstagefright_omx_intermediates)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/librtp_jni_intermediates)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/android-info.txt)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/JAVA_LIBRARIES/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/framework/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libbcinfo_intermediates)

# ICS MR2!!!!!!!!!!!!
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES/libbcinfo_intermediates)

# WAIT, I MEAN JELLY BEAN!!!!!!!!!!!!
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

# Changing where ro.carrier value is instantiated for system/build.prop
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

# Now we switched to build against Mac OS X SDK 10.6
$(call add-clean-step, rm -rf $(OUT_DIR)/host/darwin-x86/obj)

$(call add-clean-step, rm -f $(OUT_DIR)/versions_checked.mk)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/lib/*.o)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/lib/*.o)

# JB MR2!!!!!!!  AND *NO*, THIS WILL NOT BE K-WHATEVER.
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)

# Start of "K" development!
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)

# GCC 4.7
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/SHARED_LIBRARIES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/lib/*.o)

# Wait, back to some JB development!
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)

# So...  funny story.  Recall when I mentioned above the
# "JB MR2" thing?  I didn't mean that.  In fact, while I was
# writing JB MR, my head was thinking 4.2, and things got
# cross-wired as they are wont to do, and we ended up with
# JB MR2, which didn't actually exist.
#
# Well, didn't exist then.
#
# Now it does.  Say hi, JB MR2!
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/build.prop)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/APPS/*)

# For inline toolchain build
$(call add-clean-step, rm -rf $(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-inline)

# ************************************************
# NEWER CLEAN STEPS MUST BE AT THE END OF THE LIST
# ************************************************
