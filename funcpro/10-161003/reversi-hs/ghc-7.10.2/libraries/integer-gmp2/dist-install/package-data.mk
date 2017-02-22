libraries/integer-gmp2_dist-install_VERSION = 1.0.0.0
libraries/integer-gmp2_dist-install_PACKAGE_KEY = integ_2aU3IZNMF9a7mQ0OzsZ0dS
libraries/integer-gmp2_dist-install_LIB_NAME = integer-gmp-1.0.0.0-2aU3IZNMF9a7mQ0OzsZ0dS
libraries/integer-gmp2_dist-install_MODULES = GHC.Integer GHC.Integer.Logarithms GHC.Integer.Logarithms.Internals GHC.Integer.GMP.Internals GHC.Integer.Type
libraries/integer-gmp2_dist-install_HIDDEN_MODULES = GHC.Integer.Type
libraries/integer-gmp2_dist-install_SYNOPSIS =Integer library based on GMP
libraries/integer-gmp2_dist-install_HS_SRC_DIRS = src/
libraries/integer-gmp2_dist-install_DEPS = ghc-prim-0.4.0.0
libraries/integer-gmp2_dist-install_DEP_KEYS = ghcpr_8TmvWUcS1U1IKHT0levwg3
libraries/integer-gmp2_dist-install_DEP_NAMES = ghc-prim
libraries/integer-gmp2_dist-install_TRANSITIVE_DEPS = ghc-prim-0.4.0.0 rts-1.0
libraries/integer-gmp2_dist-install_TRANSITIVE_DEP_KEYS = ghcpr_8TmvWUcS1U1IKHT0levwg3 rts
libraries/integer-gmp2_dist-install_TRANSITIVE_DEP_NAMES = ghc-prim rts
libraries/integer-gmp2_dist-install_INCLUDE_DIRS = include
libraries/integer-gmp2_dist-install_INCLUDES = 
libraries/integer-gmp2_dist-install_INSTALL_INCLUDES = HsIntegerGmp.h ghc-gmp.h
libraries/integer-gmp2_dist-install_EXTRA_LIBRARIES = 
libraries/integer-gmp2_dist-install_EXTRA_LIBDIRS = 
libraries/integer-gmp2_dist-install_C_SRCS  = cbits/wrappers.c
libraries/integer-gmp2_dist-install_CMM_SRCS  := $(addprefix cbits/,$(notdir $(wildcard libraries/integer-gmp2/cbits/*.cmm)))
libraries/integer-gmp2_dist-install_DATA_FILES = 
libraries/integer-gmp2_dist-install_HC_OPTS = -this-package-key integer-gmp -Wall -XHaskell2010
libraries/integer-gmp2_dist-install_CC_OPTS = -std=c99 -Wall
libraries/integer-gmp2_dist-install_CPP_OPTS = 
libraries/integer-gmp2_dist-install_LD_OPTS = 
libraries/integer-gmp2_dist-install_DEP_INCLUDE_DIRS_SINGLE_QUOTED = '/Users/mark/Projects/ghc-7.10.2/rts/dist/build' '/Users/mark/Projects/ghc-7.10.2/includes' '/Users/mark/Projects/ghc-7.10.2/includes/dist-derivedconstants/header'
libraries/integer-gmp2_dist-install_DEP_CC_OPTS = 
libraries/integer-gmp2_dist-install_DEP_LIB_DIRS_SINGLE_QUOTED = '/Users/mark/Projects/ghc-7.10.2/libraries/ghc-prim/dist-install/build' '/Users/mark/Projects/ghc-7.10.2/rts/dist/build'
libraries/integer-gmp2_dist-install_DEP_LIB_DIRS_SEARCHPATH = /Users/mark/Projects/ghc-7.10.2/libraries/ghc-prim/dist-install/build:/Users/mark/Projects/ghc-7.10.2/rts/dist/build
libraries/integer-gmp2_dist-install_DEP_LIB_REL_DIRS = libraries/ghc-prim/dist-install/build rts/dist/build
libraries/integer-gmp2_dist-install_DEP_LIB_REL_DIRS_SEARCHPATH = libraries/ghc-prim/dist-install/build:rts/dist/build
libraries/integer-gmp2_dist-install_DEP_EXTRA_LIBS = m dl
libraries/integer-gmp2_dist-install_DEP_LD_OPTS = 
libraries/integer-gmp2_dist-install_BUILD_GHCI_LIB = NO

$(eval $(libraries/integer-gmp2_PACKAGE_MAGIC))
