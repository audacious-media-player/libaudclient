include ../../extra.mk

INCLUDES = dbus.h
CLEAN = dbus-client-bindings.h

include ../../buildsys.mk

dbus-client-bindings.h: ${DBUS_BINDINGS_SOURCES}
	${DBUS_BINDING_TOOL} --mode=glib-client --prefix=audacious_rc objects.xml > $@
