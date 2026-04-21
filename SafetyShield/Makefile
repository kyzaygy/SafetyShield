TARGET := iphone:clang:latest:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = SafetyShield

SafetyShield_FILES = main.m AppDelegate.m ViewController.m
SafetyShield_FRAMEWORKS = UIKit CoreGraphics QuartzCore
SafetyShield_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "uicache -a"
