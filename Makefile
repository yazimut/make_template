# Include global Makefile
ifndef GLOBAL
  include .global.mk
endif

# Projects list
# Note that building process is going exactly in that order!
Projects := 
ProjectsMakefiles = $(addsuffix .mk,$(Projects))

# Preparation completion flag
Prepared := False

# Default target to Make
.DEFAULT_GOAL := all

.PHONY: make-prepare make-project all
.SILENT: make-prepare make-project all

.PHONY: help self-config clean re-build install hard-install uninstall
.SILENT: help self-config clean re-build install hard-install uninstall
.NOTPARALLEL: all

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

# Build all projects
all: $(Projects)

clean: $(addsuffix .c,$(Projects))

re-build: clean all

install: $(addsuffix .i,$(Projects))

hard-install: $(addsuffix .hi,$(Projects))

uninstall: $(addsuffix .u,$(Projects))

# Build single project
%: %.mk
	@printf "\033[1;33mBuilding $(basename $@)...\033[0m\n"
	@$(MAKE) -f $<
	@printf "\033[1;32mDone!\033[0m\n"

%.c: %.mk
	@printf "\033[1;33mCleaning $(basename $@)... \033[0m"
	@$(MAKE) -f $< clean
	@printf "\033[1;32mDone!\033[0m\n"

%.i: %.mk
	@printf "\033[1;33mInstalling $(basename $@)... \033[0m"
	@$(MAKE) -f $< install
	@printf "\033[1;32mDone!\033[0m\n"

%.hi: %.mk
	@printf "\033[1;33mHard installing $(basename $@)... \033[0m"
	@$(MAKE) -f $< hard-install
	@printf "\033[1;32mDone!\033[0m\n"

%.u: %.mk
	@printf "\033[1;33mUninstalling $(basename $@)... \033[0m"
	@$(MAKE) -f $< uninstall
	@printf "\033[1;32mDone!\033[0m\n"
