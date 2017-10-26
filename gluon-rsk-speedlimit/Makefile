include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-rsk-speedlimit
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-rsk-speedlimit
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Adjust mesh-vpn bandwith based on uci config
  DEPENDS:=+gluon-core
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-rsk-speedlimit/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-rsk-speedlimit))
