dnl ** AUD_CHECK_MODULE([define name], [module], [version required],
dnl **     [informational name], [additional error message])
dnl **
dnl ** Works like PKG_CHECK_MODULES, but provides an informative
dnl ** error message if the package is not found. NOTICE! Unlike
dnl ** PKG_C_M, this macro ONLY supports one module name!
dnl **
dnl ** AUD_CHECK_MODULE([GLIB], [gtk+-2.0], [>= 2.8.0], [Gtk+2], [See http://www.gtk.org/])
AC_DEFUN([AUD_CHECK_MODULE], [
    PKG_CHECK_MODULES([$1], [$2 $3], [
    ],[
        PKG_CHECK_EXISTS([$2], [
            cv_pkg_version=`$PKG_CONFIG --modversion "$2" 2>/dev/null`
            AC_MSG_ERROR([[
$4 version $cv_pkg_version was found, but $2 $3 is required.
$5]])
        ],[
            AC_MSG_ERROR([[
Cannot find $4! If you are using binary packages based system, check that you
have the corresponding -dev/devel packages installed.
$5]])
        ])
    ])
])


dnl ** Check for GNU make
AC_DEFUN([AUD_CHECK_GNU_MAKE],[
    AC_CACHE_CHECK([for GNU make],_cv_gnu_make_command,[
    _cv_gnu_make_command=""
    for a in "$MAKE" make gmake gnumake; do
        test "x$a" = "x" && continue
        if ( sh -c "$a --version" 2>/dev/null | grep "GNU Make" >/dev/null ) ; then
            _cv_gnu_make_command="$a"
            break
        fi
    done
    ])
    if test "x$_cv_gnu_make_command" != "x" ; then
        MAKE="$_cv_gnu_make_command"
    else
        AC_MSG_ERROR([** GNU make not found. If it is installed, try setting MAKE environment variable. **])
    fi
    AC_SUBST([MAKE])dnl
])dnl


dnl Add $1 to CFLAGS and CXXFLAGS if supported
dnl ------------------------------------------

AC_DEFUN([AUD_CHECK_CFLAGS],[
    AC_MSG_CHECKING([whether the C/C++ compiler supports $1])
    OLDCFLAGS="$CFLAGS"
    CFLAGS="$CFLAGS $1 -Werror"
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[return 0;])],[
        AC_MSG_RESULT(yes)
        CFLAGS="$OLDCFLAGS $1"
        CXXFLAGS="$CXXFLAGS $1"
    ],[
        AC_MSG_RESULT(no)
        CFLAGS="$OLDCFLAGS"
    ])
])


dnl **
dnl ** Common checks
dnl **
AC_DEFUN([AUD_COMMON_PROGS], [

dnl Check for C and C++ compilers
dnl =============================
AC_REQUIRE([AC_PROG_CC])
AC_REQUIRE([AC_PROG_CXX])
AC_REQUIRE([AM_PROG_AS])
AC_REQUIRE([AC_C_BIGENDIAN])
AC_REQUIRE([AC_SYS_LARGEFILE])

if test "x$GCC" = "xyes"; then
    CFLAGS="$CFLAGS -std=gnu99 -ffast-math -Wall -pipe"
    CXXFLAGS="$CXXFLAGS -Wall -pipe"
    AUD_CHECK_CFLAGS(-Wtype-limits)
fi

dnl Enable "-Wl,-z,defs" only on Linux
dnl ==============================
AC_MSG_CHECKING([for Linux])
case "$target" in
    *linux*)
        AC_MSG_RESULT([yes])
        LDFLAGS="$LDFLAGS -Wl,-z,defs"
        ;;
    *)
        AC_MSG_RESULT([no])
        ;;
esac

dnl Checks for various programs
dnl ===========================
AUD_CHECK_GNU_MAKE
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PATH_PROG([RM], [rm])
AC_PATH_PROG([MV], [mv])
AC_PATH_PROG([CP], [cp])
AC_PATH_PROG([AR], [ar])
AC_PATH_PROG([TR], [tr])
AC_PATH_PROG([RANLIB], [ranlib])

dnl Check for Gtk+/GLib and pals
dnl ============================
AUD_CHECK_MODULE([GLIB], [glib-2.0], [>= 2.28], [Glib2])

])
