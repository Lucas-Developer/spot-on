include(spot-on-kernel-source.pro)
libntru.target = libntru.dylib
libntru.commands = $(MAKE) -C ../../../libNTRU
libntru.depends =
libspoton.target = libspoton.dylib
libspoton.commands = $(MAKE) -C ../../../libSpotOn library
libspoton.depends =
purge.commands = rm -f *~

TEMPLATE	= app
LANGUAGE	= C++
QT		+= network sql
QT		-= gui
CONFIG		+= qt release warn_on app_bundle

# The function gcry_kdf_derive() is available in version
# 1.5.0 of the gcrypt library.

DEFINES += SPOTON_LINKED_WITH_LIBGEOIP \
           SPOTON_LINKED_WITH_LIBNTRU \
	   SPOTON_LINKED_WITH_LIBPTHREAD \
           SPOTON_MCELIECE_ENABLED \
	   SPOTON_SCTP_ENABLED

# Unfortunately, the clean target assumes too much knowledge
# about the internals of libNTRU and libSpotOn.

QMAKE_CLEAN     += ../Spot-On-Kernel ../../../libNTRU/*.dylib \
                   ../../../libNTRU/src/*.o ../../../libNTRU/src/*.s \
		   ../../../libSpotOn/*.dylib \
		   ../../../libSpotOn/*.o ../../../libSpotOn/test
QMAKE_DISTCLEAN += -r temp
QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_CXXFLAGS_RELEASE += -fPIE -fstack-protector-all -fwrapv \
			  -mtune=generic -pie -O3 \
			  -Wall -Wcast-align -Wcast-qual \
                          -Werror -Wextra \
			  -Woverloaded-virtual -Wpointer-arith \
			  -Wstack-protector -Wstrict-overflow=5
QMAKE_EXTRA_TARGETS = libntru libspoton ntl purge
QMAKE_LFLAGS_RELEASE =
QMAKE_LFLAGS_RPATH =
INCLUDEPATH	+= . ../. ../../../. \
		   ../../../libSCTP/Include.osx64 \
                   /usr/local/include /usr/local/opt
ICON		=
LIBS		+= -L../../../libNTRU -lntru \
		   -L../../../libSCTP/Libraries.osx64 -lusrsctp \
                   -L../../../libSpotOn -lspoton \
                   -L/usr/local/lib -L/usr/local/opt/curl/lib \
                   -L/usr/local/opt/openssl/lib -lGeoIP \
                   -lcrypto -lcurl -lgcrypt -lgpg-error -lpq -lssl
PRE_TARGETDEPS = libntru.dylib libspoton.dylib ntl.a
OBJECTS_DIR = temp/obj
UI_DIR = temp/ui
MOC_DIR = temp/moc
RCC_DIR = temp/rcc

TARGET		= ../Spot-On-Kernel
PROJECTNAME	= Spot-On-Kernel

# Prevent qmake from stripping everything.

QMAKE_STRIP	= echo

spoton.path		= /Applications/Spot-On.d/Spot-On-Kernel.app
spoton.files		= ../Spot-On-Kernel.app/*
libgeoip_data_install.path = /Applications/Spot-On.d/GeoIP
libgeoip_data_install.files = ../../../GeoIP/Data/GeoIP.dat
libntru_install.path  = .
libntru_install.extra = cp ../../../libNTRU/libntru.dylib ../Spot-On-Kernel.app/Contents/Frameworks/libntru.dylib && install_name_tool -change ../../../libNTRU/libntru.dylib @executable_path/../Frameworks/libntru.dylib ../Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
libsctp_install.path  = .
libsctp_install.extra = cp ../../../libSCTP/Libraries.osx64/libusrsctp.0.dylib ../Spot-On-Kernel.app/Contents/Frameworks/libusrsctp.0.dylib && install_name_tool -change ../../../libSCTP/Libraries.osx64/libusrsctp.0.dylib @executable_path/../Frameworks/libusrsctp.0.dylib ../Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
libspoton_install.path  = .
libspoton_install.extra = cp ../../../libSpotOn/libspoton.dylib ../Spot-On-Kernel.app/Contents/Frameworks/libspoton.dylib && install_name_tool -change /usr/local/opt/libgcrypt/lib/libgcrypt.20.dylib @loader_path/libgcrypt.20.dylib ../Spot-On-Kernel.app/Contents/Frameworks/libspoton.dylib && install_name_tool -change ../../../libSpotOn/libspoton.dylib @executable_path/../Frameworks/libspoton.dylib ../Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
macdeployqt.path        = ../Spot-On-Kernel.app
macdeployqt.extra       = $$[QT_INSTALL_BINS]/macdeployqt ../Spot-On-Kernel.app -verbose=0
preinstall.path         = /Applications/Spot-On.d
preinstall.extra        = rm -rf /Applications/Spot-On.d/Spot-On-Kernel.app/*
postinstall.path	= /Applications/Spot-On.d
postinstall.extra	= find /Applications/Spot-On.d -name .svn -exec rm -rf {} \\; 2>/dev/null; echo

INSTALLS	= macdeployqt \
                  preinstall \
                  libgeoip_data_install \
                  libntru_install \
		  libsctp_install \
                  libspoton_install \
                  spoton \
                  postinstall
