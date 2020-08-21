DOTFILES_ROOT := $(realpath ./)
CANDIDATES    := $(wildcard .??*) bin
EXCLUSIONS    := .DS_Store .git .gitmodules
DOTFILES      := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symbolic links to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init: ## Setup environment settings
	@$(foreach val, $(wildcard ./etc/init/*.sh), DOTFILES_ROOT=$(DOTFILES_ROOT) bash $(DOTFILES_ROOT)/$(val);)

update: ## Fetch changes for this repo
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install: update deploy init ## Run make update, deploy, init
	@exec $$SHELL

clean: ## Remove the dot files and this repo.
	@echo 'Remove dotfiles in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTFILES_ROOT)

help: ## Show Self-documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
