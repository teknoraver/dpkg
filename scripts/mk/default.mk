# This Makefile fragment (since dpkg 1.16.1) includes all the Makefile
# fragments that define variables that can be useful within debian/rules.

ifndef dpkg_default_mk_included
dpkg_default_mk_included = yes

dpkg_datadir = $(srcdir)/mk
include $(dpkg_datadir)/architecture.mk
include $(dpkg_datadir)/buildapi.mk
ifeq ($(call dpkg_build_api_ge,1),yes)
include $(dpkg_datadir)/buildtools.mk
endif
include $(dpkg_datadir)/buildflags.mk
include $(dpkg_datadir)/buildopts.mk
include $(dpkg_datadir)/pkg-info.mk
include $(dpkg_datadir)/vendor.mk

endif # dpkg_default_mk_included
