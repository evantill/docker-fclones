INSTALL_DIR ?= "$(HOME)/.local/bin"
INSTALL_BIN ?= "$(INSTALL_DIR)/fclones"

DOCKER_IMAGE_NAME ?= "evantill/fclones"
DOCKER_IMAGE_VERSION ?= "latest"

help: ## Prints tasks descriptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

install: ## Build docker image and install wrapper script into INSTALL_DIR (default to $HOME/.local/bin)
install: build installScript

build:
	@docker-compose build

installScript:
ifeq "$(shell test -f $(INSTALL_BIN) && echo 1 || echo 0)" "1"
	$(error $(INSTALL_BIN) already exist)
endif
	@cp scripts/fclones.sh $(INSTALL_BIN)
	@echo "$(INSTALL_BIN) has been installed"

uninstall: ## Remove docker image and wrapper script
uninstall: cleanDockerImage uninstallScript

cleanDockerImage:
ifeq "$(shell docker images | grep $(DOCKER_IMAGE_NAME) >/dev/null; echo $$?)" "0"
	docker rmi $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
endif

uninstallScript:
	@test ! -f $(INSTALL_BIN) || (rm $(INSTALL_BIN);echo "$(INSTALL_BIN) has been removed")

clean: ## Alias for uninstall
clean: uninstall

run: ## Use ./scripts/fclones.sh to run fclones instrad of this make target
	$(error use ./scripts/fclones.sh to run fclones)

