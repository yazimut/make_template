export GLOBAL := True

# Validate Make version
MMRV := 4.4.1
ifneq ($(MAKE_VERSION), $(MMRV))
    VERSION_TEST := $(shell echo "$(MAKE_VERSION)\n$(MMRV)" | sort -V -t '.' | tail --lines=1)
    ifeq ($(VERSION_TEST), $(MMRV))
        $(error Minimum required version of Make is $(MMRV); your's is $(MAKE_VERSION))
    endif
endif

ifndef VERBOSE
  MAKEFLAGS += --no-print-directory
endif

# Special instruction NOP - "Do nothing"
export nop := @echo "ђ" > /dev/null

# Paths
export SolutionDir := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
export Includes    := include
export Sources     := src
export Bins        := bin
export LDs         := $(Bins)
export Tmps        := tmp

# Default configuration
export Config ?= Debug

# Global C/C++ defines
ifeq ($(Config), Debug)
  export Defines := DEBUG
else
  export Defines := 
endif
