# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# lcms1
PKG             := lcms1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19
$(PKG)_CHECKSUM := d5b075ccffc0068015f74f78e4bc39138bcfe2d4
$(PKG)_SUBDIR   := lcms-$($(PKG)_VERSION)
$(PKG)_FILE     := lcms-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.littlecms.com/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lcms/lcms/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/lcms/files/lcms/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep '^1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
