# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GtkGLExt
PKG             := gtkglext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := db9ce38ee555fd14f55083ec7f4ae30e5338d5cc
$(PKG)_SUBDIR   := gtkglext-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglext-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://gtkglext.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglext/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtkglext/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --without-x \
        --with-gdktarget=win32 \
        --disable-gtk-doc \
        --disable-man \
        --disable-glibtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS= \
        GDKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`' \
        GTKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`'

    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtkglext.exe' \
        `'$(TARGET)-pkg-config' gtkglext-1.0 --cflags --libs`
endef
