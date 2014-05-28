export THEOS_DEVICE_IP =  10.8.0.94
export ARCHS= armv7 arm64
export TARGET=iphone:latest:4.3
SDKVERSION = 7.0

include theos/makefiles/common.mk

TWEAK_NAME = 2048AI
2048AI_FILES = Tweak.xm AI.mm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 2048"
