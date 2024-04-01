# Include global Makefile
ifndef GLOBAL
  include .global.mk
endif

# Suffixes
  OBJ_SUFFIX          := o
  MAKEDEPS_SUFFIX     := mk

# Project: PROJECT_NAME
  ProjectName         := PROJECT_NAME
  Project             := $(ProjectName).elf
  Target              := $(Bins)/$(Project)
  CC_Objects          := $(patsubst $(Sources)/%.c,$(Tmps)/%.$(OBJ_SUFFIX),$(wildcard $(Sources)/$(ProjectName)/*.c))
  CPP_Objects         := $(patsubst $(Sources)/%.cpp,$(Tmps)/%.$(OBJ_SUFFIX),$(wildcard $(Sources)/$(ProjectName)/*.cpp))
  MakeDeps            := $(wildcard $(Tmps)/$(ProjectName)/*.$(MAKEDEPS_SUFFIX))
  Defines             += 
  Includes            += 
  LDs                 += 
  Libraries           := 

# Toolchain
#   C compiler
    CC                := gcc
    CC_Debug          := -g3 -Og
    CC_CompilerFlags   = $(CC_Debug) $(addprefix -I,$(Includes)) $(addprefix -D,$(Defines))
    CC_CompilerFlags  += -MMD -MF $(patsubst $(Sources)/%.c,$(Tmps)/%.$(MAKEDEPS_SUFFIX),$<)
    CC_CompilerFlags  += -std=c17 -c
    CC_LinkerFlags     = $(addprefix -L,$(LDs))
    CC_LinkerFlags    += 

#   C++ compiler
    CPP               := g++
    CPP_Debug         := -g3 -Og
    CPP_CompilerFlags  = $(CPP_Debug) $(addprefix -I,$(Includes)) $(addprefix -D,$(Defines))
    CPP_CompilerFlags += -MMD -MF $(patsubst $(Sources)/%.cpp,$(Tmps)/%.$(MAKEDEPS_SUFFIX),$<)
    CPP_CompilerFlags += -std=c++17 -c
    CPP_LinkerFlags    = $(addprefix -L,$(LDs))
    CPP_LinkerFlags   += 

.PHONY: help self-config clean hard-clean re-build install hard-install uninstall
.SILENT: help self-config clean hard-clean re-build install hard-install uninstall

.DEFAULT_GOAL := $(ProjectName)
.PHONY: $(ProjectName)

#   -80-    "--------------------------------------------------------------------------------"
# Help
help:
	@printf "\033[1;33mUsage: \033[0m"
	@printf "\033[1;31mmake -f $(ProjectName).mk\033[0m [Config=<cfg>] [Action]"
	@printf "\n"
	@printf "    Config=<cfg>    - Set build configuration to \"cfg\"\n"
	@printf "                    Can be \"Debug\" or \"Release\"\n"
	@printf "                    Default is \"Debug\"\n"
	@printf "    Action          - What should be done with project\n"
	@printf "                    Can be \"clean\", \"hard-clean\" \"re-build\", \n"
	@printf "                    \"install\", \"hard-install\" or \"uninstall\"\n"
	@printf "\n"
	@printf "  \033[1;33mExamples: \033[0m\n"
	@printf "    make -f $(ProjectName).mk                         - Build project\n"
	@printf "    make -f $(ProjectName).mk Config=Release re-build - Re-build project \n"
	@printf "                                                     in Release configuration"
	@printf "\n"

# Auto detect configuration
self-config:
  ifeq ($(Config), Debug)
    # Debug configuration
    CC_Debug := -g3 -Og
    CPP_Debug := -g3 -Og
  else
    ifeq ($(Config), Release)
      # Release configuration
      CC_Debug := -g0 -O2
      CPP_Debug := -g0 -O2
    else
      # Wrong configuration 
	    $(error Invalid configuration "$(Config)")
    endif
  endif



# ------------------------------------------------------------------------------
# Recipes
# ------------------------------------------------------------------------------

# C sources
$(Tmps)/%.o: $(Sources)/%.c
	$(CC) $(CC_CompilerFlags) -o $@ $<

# C++ sources
$(Tmps)/%.o: $(Sources)/%.cpp
	$(CPP) $(CPP_CompilerFlags) -o $@ $<

# Include project recipes
include $(MakeDeps)

$(ProjectName): self-config .WAIT $(Target)

clean:
	@rm -f $(Target)
	@rm -f $(Tmps)/$(ProjectName)/*.$(OBJ_SUFFIX)
	@rm -f $(Tmps)/$(ProjectName)/*.$(MAKEDEPS_SUFFIX)

hard-clean:
	@rm -f $(Target)
	@rm -f $(Tmps)/$(ProjectName)/*
	@touch $(Tmps)/$(ProjectName)/.gitkeep

re-build: clean $(Target)

install:
	@$(nop)

hard-install:
	@$(nop)

uninstall:
	@$(nop)

$(Target): $(CC_Objects) $(CPP_Objects)
	$(CPP) $(CPP_LinkerFlags) -o $@ $+ $(addprefix -l,$(Libraries))
