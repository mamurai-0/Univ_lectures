libraries/integer-gmp2_PACKAGE = integer-gmp
libraries/integer-gmp2_dist-install_GROUP = libraries
$(if $(filter integer-gmp2,$(PACKAGES_STAGE0)),$(eval $(call build-package,libraries/integer-gmp2,dist-boot,0)))
$(if $(filter integer-gmp2,$(PACKAGES_STAGE1)),$(eval $(call build-package,libraries/integer-gmp2,dist-install,1)))
$(if $(filter integer-gmp2,$(PACKAGES_STAGE2)),$(eval $(call build-package,libraries/integer-gmp2,dist-install,2)))
