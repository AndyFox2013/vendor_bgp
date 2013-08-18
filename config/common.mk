PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/bgp/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions 
    
# SuperSU
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/xbin/su:system/xbin/su \
    vendor/bgp/prebuilt/common/xbin/daemonsu:system/xbin/daemonsu \
    vendor/bgp/prebuilt/common/app/Superuser.apk:system/app/Superuser.apk

# BGP-specific init file
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/etc/init.local.rc:root/init.BGP.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/bgp/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Audio Config for DSPManager
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/vendor/etc/audio_effects.conf:system/vendor/etc/audio_effects.conf
#LOCAL BGP CHANGES  - END

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/bgp/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/bgp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/bgp/prebuilt/common/bin/sysinit:system/bin/sysinit

# Workaround for NovaLauncher zipalign fails
PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/app/NovaLauncher.apk:system/app/NovaLauncher.apk

# Required packages
PRODUCT_PACKAGES += \
    Camera \
    Development 

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    HoloSpiralWallpaper \
    NoiseField \
    Galaxy4 \
    LiveWallpapersPicker \
    PhaseBeam

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME 

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs

PRODUCT_PACKAGE_OVERLAYS += vendor/bgp/overlay/common

# T-Mobile theme engine
# include vendor/bgp/config/themes_common.mk

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/bgp/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/bgp/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

# Versioning System
PRODUCT_VERSION_MAJOR = 4.3
PRODUCT_VERSION_MINOR = beta
PRODUCT_VERSION_MAINTENANCE = 1
ifdef BGP_BUILD_EXTRA
    BGP_POSTFIX := -$(BGP_BUILD_EXTRA)
endif

# Set all versions
BGP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(BGP_BUILD_TYPE)$(BGP_POSTFIX)
BGP_MOD_VERSION := $(BGP_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(BGP_BUILD_TYPE)$(BGP_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    bgp.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.bgp.version=$(BGP_VERSION) \
    ro.modversion=$(BGP_MOD_VERSION)
