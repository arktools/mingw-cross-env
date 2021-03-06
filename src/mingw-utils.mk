# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MinGW Utilities
PKG             := mingw-utils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4-1
$(PKG)_CHECKSUM := 716f51d7622b36448fc1e92d2c69d8f41b1cc2df
$(PKG)_SUBDIR   := $(PKG)-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-mingw32-src.tar.lzma
$(PKG)_WEBSITE  := http://www.mingw.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Extension/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Extension/mingw-utils/' | \
    $(SED) -n 's,.*mingw-utils-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build
    cp -Rp '$(1)' '$(1).native'
    cd '$(1).native' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)'
    $(MAKE) -C '$(1).native/reimp' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1).native/reimp/reimp' '$(PREFIX)/bin/$(TARGET)-reimp'

    # cross build
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
