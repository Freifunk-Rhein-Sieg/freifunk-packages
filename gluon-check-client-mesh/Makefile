include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-check-client-mesh
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-check-client-mesh
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Check Client Mesh based on uci rsk.checkmesh config
  DEPENDS:=+gluon-core +gluon-rsk-config +iw-full
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-check-client-mesh/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-check-client-mesh))
