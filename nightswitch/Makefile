include $(TOPDIR)/rules.mk

PKG_NAME:=lohmar-nightswitch
PKG_VERSION:=2
PKG_RELEASE:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/lohmar-nightswitch
  SECTION:=daemon
  CATEGORY:=Freifunk Lohmar
  TITLE:=Switch Wifi based on uci nighswitch config
endef

define Package/lohmar-nightswitch/description
        Switch Wifi based on uci nightswitch config
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/lohmar-nightswitch/install
    $(INSTALL_DIR) $(1)/usr/lib/micron.d/
    $(INSTALL_DATA) files/usr/lib/micron.d/nightswitch $(1)/usr/lib/micron.d/nightswitch
    $(INSTALL_DIR) $(1)/lib/lohmar/nightswitch/
    $(INSTALL_BIN) files/lib/lohmar/nightswitch/nightswitch.sh $(1)/lib/lohmar/nightswitch/
endef

$(eval $(call BuildPackage,lohmar-nightswitch))
