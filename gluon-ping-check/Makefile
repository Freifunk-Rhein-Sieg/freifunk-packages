include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ping-check
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-ping-check
  SECTION:=daemon
  CATEGORY:=Freifunk Rhein-Sieg
  TITLE:=Restart wifi or reboot node on wifi hang
endef

define Package/gluon-ping-check/description
        Restart wifi or reboot node on wifi hang based on rsk config
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-ping-check/install
		$(INSTALL_DIR) $(1)/usr/lib/micron.d/
		$(INSTALL_DATA) files/usr/lib/micron.d/pingcheck $(1)/usr/lib/micron.d/pingcheck
		$(INSTALL_DIR) $(1)/lib/rsk/gluon-ping-check/
		$(INSTALL_BIN) files/lib/rsk/gluon-ping-check/pingcheck.sh $(1)/lib/rsk/gluon-ping-check/
endef

$(eval $(call BuildPackage,gluon-ping-check))
