# Include global Makefile
ifndef GLOBAL
  include .global.mk
endif

# Projects list
# Note that building process is going exactly in that order!
Projects := lib dll app
ProjectsMakefiles = $(addsuffix .mk,$(Projects))

# Preparation completion flag
Prepared := True

# Default target to Make
.DEFAULT_GOAL := all

.PHONY: make-prepare make-project all
.SILENT: make-prepare make-project all

.PHONY: help self-config clean re-build install hard-install uninstall
.SILENT: help self-config clean re-build install hard-install uninstall

# Help
help:
	@printf "\033[1;33mUsage: \033[0m"
	@printf "\033[31mmake\033[0m [Config=<cfg>] [Action]\n"
	@printf "\n"
	@printf "    Config=<cfg>                       - Set build configuration to \"cfg\"\n"
	@printf "                                         Can be \"Debug\" or \"Release\"\n"
	@printf "    Action                             - What should be done\n"
	@printf "\n"
	@printf "  \033[1;33mExamples: \033[0m\n"
	@printf "    make                                       - Build whole solution\n"
	@printf "    make Config=Release re-build               - Re-build whole solution in Release configuration\n"
	@printf "    make make-prepare                          - Create solution directories structure\n"
	@printf "    make make-project ProjectName=MyProject    - Create new project \"MyProject\""
	@printf "\n"

# Preparing solution directory
make-prepare:
	mkdir -p $(Bins)
	mkdir -p $(Includes)
	mkdir -p $(Sources)
	mkdir -p $(Tmps)
	touch $(Bins)/.gitkeep
	touch $(Includes)/.gitkeep
	touch $(Sources)/.gitkeep
	touch $(Tmps)/.gitkeep

  ifneq ($(Prepared),True)
	for project in $(Projects); do \
		$(MAKE) make-project ProjectName=$$project; \
	done
	sed -i -e 's/Prepared\ :=\ False/Prepared\ :=\ True/g' Makefile
  endif

# Create new project $(ProjectName)
make-project:
  ifneq ($(ProjectName),)
	mkdir -p $(Includes)/$(ProjectName)
	mkdir -p $(Sources)/$(ProjectName)
	mkdir -p $(Tmps)/$(ProjectName)
	touch $(Includes)/$(ProjectName)/.gitkeep
	touch $(Sources)/$(ProjectName)/.gitkeep
	touch $(Tmps)/$(ProjectName)/.gitkeep

	cp -n .template.mk $(ProjectName).mk
	sed -i -e 's/Application/$(ProjectName)/g' $(ProjectName).mk
	
  ifeq ($(Prepared),True)
	sed -i -e 's/Projects\ :=/Projects\ :=\ $(ProjectName)/g' Makefile
  endif
	
	@echo "\033[33mDirectories tree for project \"$(ProjectName)\" has been created.\033[0m"
	@echo "\033[33mModify $(ProjectName).mk to add project specific targets.\033[0m"
  else
	$(error Invalid project name "$(ProjectName)". See "make help")
  endif

# Do something for every project
# Parameter $(1) - makefile target
define forAnyProject
	for project in $(ProjectsMakefiles); do \
		$(MAKE) -f $$project $(1); \
	done
endef

# Build all projects
all:
	@$(call color-echo,Building whole solution...,1;33)
	@$(call forAnyProject)
	@$(call color-echo,Build complete!,1;32)

clean:
	@$(call forAnyProject,clean)

re-build: clean all

install:
	@$(call color-echo,Installing whole solution...,1;33)
	@$(call forAnyProject,install)
	@$(call color-echo,Installation complete!,1;32)

hard-install:
	@$(call color-echo,Installing whole solution...,1;33)
	@$(call forAnyProject,hard-install)
	@$(call color-echo,Installation complete!,1;32)

uninstall: 
	@$(call color-echo,Uninstalling whole solution...,1;33)
	@$(call forAnyProject,uninstall)
	@$(call color-echo,Uninstallation complete!,1;32)

# Build single project
%: %.mk
	@$(MAKE) -f $<
