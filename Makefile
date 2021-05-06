TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = Q5AWL8WCY6.iMapMyRun


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MapMyRunSpoofer

MapMyRunSpoofer_FILES = Tweak.x
MapMyRunSpoofer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
