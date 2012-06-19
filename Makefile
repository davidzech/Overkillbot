include theos/makefiles/common.mk

TWEAK_NAME = Overkillbot
Overkillbot_FILES = Tweak.xm

Overkillbot_FRAMEWORKS = UIKit OpenGLES

include $(THEOS_MAKE_PATH)/tweak.mk
