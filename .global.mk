export GLOBAL := True

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

# Function to color echo
# Parameter $(1) - text to echo
# Parameter $(2) - color (echo man)
define color-echo
	@echo ""
	@echo "\033[$(2)m--------------------------------\033[0m"
	@echo "\033[$(2)m$(1)\033[0m"
	@echo "\033[$(2)m--------------------------------\033[0m"
	@echo "" 
endef
