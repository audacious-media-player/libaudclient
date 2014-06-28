dnl ***
dnl *** Process this file with autoconf to produce a configure script.
dnl ***

dnl Initialize
dnl ==========
AC_PREREQ([2.59])
AC_INIT([libaudclient], [3.5-rc2])
AC_COPYRIGHT([(C) 2005-2014 Audacious Team])

AC_SUBST([PACKAGE], [AC_PACKAGE_TARNAME])
AC_SUBST([VERSION], [AC_PACKAGE_VERSION])
AC_DEFINE_UNQUOTED([PACKAGE], "$PACKAGE", [Name of package])
AC_DEFINE_UNQUOTED([VERSION], "$VERSION", [Version number of package])

AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])

AC_PROG_INSTALL
AUD_COMMON_PROGS

BUILDSYS_INIT
BUILDSYS_SHARED_LIB

m4_ifdef([PKG_INSTALLDIR], [PKG_INSTALLDIR], AC_SUBST([pkgconfigdir], ${libdir}/pkgconfig))

dnl Platform
dnl ========
AC_MSG_CHECKING([for Microsoft Windows])
case "$target" in
    *mingw*)
        AC_MSG_RESULT([yes])
        HAVE_MSWINDOWS="yes"
        ;;
    *)
        AC_MSG_RESULT([no])
        HAVE_MSWINDOWS="no"
        ;;
esac
AC_SUBST([HAVE_MSWINDOWS])

dnl Prevent symbol collisions
dnl =========================
if test "x$HAVE_MSWINDOWS" = "xyes" ; then
    EXPORT="__declspec(dllexport)"
elif test "x$GCC" = "xyes" ; then
    CFLAGS="$CFLAGS -fvisibility=hidden"
    CXXFLAGS="$CXXFLAGS -fvisibility=hidden"
    EXPORT="__attribute__((visibility(\"default\")))"
else
    AC_MSG_ERROR([Unknown syntax for EXPORT keyword])
fi
AC_DEFINE_UNQUOTED([EXPORT], [$EXPORT], [Define to compiler syntax for public symbols])

dnl D-Bus support
dnl =============
PKG_CHECK_MODULES([DBUS], [dbus-1 >= 0.60 dbus-glib-1 >= 0.60])

AC_PATH_PROG([DBUS_BINDING_TOOL], [dbus-binding-tool], [no])
if test "x$DBUS_BINDING_TOOL" = "xno" ; then
    AC_MSG_ERROR([dbus-binding-tool not found])
else
    LIBAUDCLIENT_LDFLAGS="-laudclient"
    AC_SUBST([DBUS_CFLAGS])
    AC_SUBST([DBUS_LIBS])
    AC_SUBST([DBUS_BINDING_TOOL])
    AC_SUBST([LIBAUDCLIENT_LDFLAGS])
fi

dnl Reliably #include "config.h" (for large file support)
dnl =====================================================
CPPFLAGS="$CPPFLAGS -include config.h"

dnl Output configuration files
dnl ==========================
AC_CONFIG_FILES([
    audclient.pc
    buildsys.mk
    extra.mk
])

BUILDSYS_TOUCH_DEPS
AC_OUTPUT

dnl Print out the results
dnl =====================
echo ""
echo "Configuration:"
echo ""
echo "  Install path:                           $prefix"
echo ""
