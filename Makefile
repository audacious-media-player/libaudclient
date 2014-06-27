SUBDIRS = src

DISTCLEAN = audclient.pc buildsys.mk config.h config.log config.status extra.mk

include buildsys.mk

install-extra:
	for i in audclient.pc; do \
	        ${INSTALL_STATUS}; \
		if ${MKDIR_P} ${DESTDIR}${pkgconfigdir} && ${INSTALL} -m 644 $$i ${DESTDIR}${pkgconfigdir}/$$i; then \
			${INSTALL_OK}; \
		else \
			${INSTALL_FAILED}; \
		fi; \
	done

uninstall-extra:
	for i in audclient.pc; do \
		if [ -f ${DESTDIR}${pkgconfigdir}/$$i ]; then \
			if rm -f ${DESTDIR}${pkgconfigdir}/$$i; then \
				${DELETE_OK}; \
			else \
				${DELETE_FAILED}; \
			fi \
		fi; \
	done
