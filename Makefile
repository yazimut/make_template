# Include global Makefile
ifndef GLOBAL
  include .global.mk
endif

# Building order
# Add .WAIT to finish building left-side projects
# This is important for parallel compilation (-j flag)
BuildingOrder := 

# Projects list
Projects      := $(subst .WAIT, ,$(BuildingOrder))

# Preparation completion flag
Prepared := False

# Default target to Make
.DEFAULT_GOAL := all

.PHONY: make-prepare make-project all
.SILENT: make-prepare make-project all

.PHONY: help self-config clean hard-clean re-build install hard-install uninstall
.SILENT: help self-config clean hard-clean re-build install hard-install uninstall

#   -80-    "--------------------------------------------------------------------------------"
# Help
help:
	@printf "\033[1;33mUsage: \033[0m"
	@printf "\033[31mmake\033[0m [Config=<cfg>] [Action]\n"
	@printf "\n"
	@printf "    Config=<cfg>                       - Set build configuration to \"cfg\"\n"
	@printf "                                         Can be \"Debug\" or \"Release\"\n"
	@printf "                                         Default is \"Debug\"\n"
	@printf "    Action                             - What should be done\n"
	@printf "\n"
	@printf "  \033[1;33mExamples: \033[0m\n"
	@printf "    make                                       - Build whole solution\n"
	@printf "    make Config=Release re-build               - Re-build whole solution \n"
	@printf "                                                 in Release configuration\n"
	@printf "    make make-prepare                          - Create solution directories \n"
	@printf "                                                 structure\n"
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
	mkdir $(Includes)/$(ProjectName)
	mkdir $(Sources)/$(ProjectName)
	mkdir $(Tmps)/$(ProjectName)
	touch $(Includes)/$(ProjectName)/.gitkeep
	touch $(Sources)/$(ProjectName)/.gitkeep
	touch $(Tmps)/$(ProjectName)/.gitkeep

	cp -n .template.mk $(ProjectName).mk
	sed -i -e 's/PROJECT_NAME/$(ProjectName)/g' $(ProjectName).mk
	
    ifeq ($(Prepared),True)
	  sed -i -e 's/BuildingOrder\ :=/BuildingOrder\ :=\ $(ProjectName)/g' Makefile
    endif
	
	@echo "\033[33mDirectories tree for project \"$(ProjectName)\" has been created.\033[0m"
	@echo "\033[33mModify $(ProjectName).mk to add project specific targets.\033[0m"
  else
	$(error Invalid project name "$(ProjectName)". See "make help")
  endif

# All projects
all: $(BuildingOrder)

clean: $(addsuffix .c,$(Projects))

hard-clean: $(addsuffix .hc,$(Projects))

re-build: clean .WAIT all

install: $(addsuffix .i,$(Projects))

hard-install: $(addsuffix .hi,$(Projects))

uninstall: $(addsuffix .u,$(Projects))

# Single project
%: %.mk
#   build
	@printf "\033[1;33mBuilding $(basename $<)...\033[0m\n"
	@$(MAKE) -f $<
	@printf "\033[1;33mBuilding $(basename $<): \033[0m"
	@printf "\033[1;32mDone!\033[0m\n"

%.c: %.mk
#   clean
	@printf "\033[1;33mCleaning $(basename $<)... \033[0m"
	@$(MAKE) -f $< clean
	@printf "\033[1;32mDone!\033[0m\n"

%.hc: %.mk
#   hard-clean
	@printf "\033[1;33mHard cleaning $(basename $<)... \033[0m"
	@$(MAKE) -f $< hard-clean
	@printf "\033[1;32mDone!\033[0m\n"

%.rb: %.c .WAIT %
#   re-build
	$(nop)

%.i: %.mk
#   install
	@printf "\033[1;33mInstalling $(basename $<)... \033[0m"
	@$(MAKE) -f $< install
	@printf "\033[1;32mDone!\033[0m\n"

%.hi: %.mk
#   hard-install
	@printf "\033[1;33mHard installing $(basename $<)... \033[0m"
	@$(MAKE) -f $< hard-install
	@printf "\033[1;32mDone!\033[0m\n"

%.u: %.mk
#   uninstall
	@printf "\033[1;33mUninstalling $(basename $<)... \033[0m"
	@$(MAKE) -f $< uninstall
	@printf "\033[1;32mDone!\033[0m\n"
