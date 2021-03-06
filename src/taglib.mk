# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# TagLib
PKG             := taglib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7
$(PKG)_CHECKSUM := 5138e1665182bc2171e298ff31518c9ad72ddf23
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://developer.kde.org/~wheeler/taglib.html
$(PKG)_URL      := http://developer.kde.org/~wheeler/files/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://developer.kde.org/~wheeler/files/src/?C=M;O=D' | \
    $(SED) -n 's,.*"taglib-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DENABLE_STATIC=ON
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
