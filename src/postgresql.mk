# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PostgreSQL
PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.1.2
$(PKG)_CHECKSUM := 7d57b96eb1c764ec234c72b70511a5f7e23fb2b0
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.postgresql.org/
$(PKG)_URL      := http://ftp.postgresql.org/pub/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib openssl

define $(PKG)_UPDATE
    wget -q -O- 'http://git.postgresql.org/gitweb?p=postgresql.git;a=tags' | \
    grep 'refs/tags/REL9[0-9_]*"' | \
    $(SED) 's,.*refs/tags/REL\(.*\)".*,\1,g;' | \
    $(SED) 's,_,.,g' | \
    grep -v '^9\.\0' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cp -Rp '$(1)' '$(1).native'
    # Since we build only client libary, use bogus tzdata to satisfy configure.
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --with-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --with-zlib \
        --with-system-tzdata=/dev/null \
        LIBS="-lsecur32 `'$(TARGET)-pkg-config' openssl --libs`"
    $(MAKE) -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' install haslibarule= shlib=
    $(MAKE) -C '$(1)'/src/port             -j '$(JOBS)'         haslibarule= shlib=
    $(MAKE) -C '$(1)'/src/bin/psql         -j '$(JOBS)' install haslibarule= shlib=
    $(INSTALL) -m644 '$(1)/src/include/pg_config.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/src/include/postgres_ext.h' '$(PREFIX)/$(TARGET)/include/'
    # Build a native pg_config.
    $(SED) -i 's,-DVAL_,-D_DISABLED_VAL_,g' '$(1).native'/src/bin/pg_config/Makefile
    cd '$(1).native' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --without-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --without-zlib \
        --with-system-tzdata=/dev/null
    $(MAKE) -C '$(1).native'/src/port          -j '$(JOBS)'
    $(MAKE) -C '$(1).native'/src/bin/pg_config -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/pg_config' '$(PREFIX)/bin/$(TARGET)-pg_config'
endef