include $(TOPDIR)/rules.mk

PKG_NAME:=rsk-robinson
PKG_VERSION:=2
PKG_RELEASE:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/rsk-robinson
  SECTION:=daemon
  CATEGORY:=Freifunk Rhein-Sieg
  TITLE:=Reboot Robinson Nodes after 5 days uptime
endef

define Package/rsk-robinson/description
        Reboot Robinson nodes based on rsk config
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/rsk-robinson/install
		$(INSTALL_DIR) $(1)/usr/lib/micron.d/
		$(INSTALL_DATA) files/usr/lib/micron.d/robinson $(1)/usr/lib/micron.d/robinson
		$(INSTALL_DIR) $(1)/lib/rsk/robinson/
		$(INSTALL_BIN) files/lib/rsk/robinson/robinson.sh $(1)/lib/rsk/robinson/
endef

$(eval $(call BuildPackage,rsk-robinson))
