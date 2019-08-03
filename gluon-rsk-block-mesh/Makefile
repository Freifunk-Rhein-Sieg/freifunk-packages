include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-rsk-block-mesh
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-rsk-block-mesh
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Adjust mesh-vpn bandwith based on uci config
  DEPENDS:=+gluon-core +gluon-rsk-config +iw-full
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-rsk-block-mesh/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-rsk-block-mesh))
