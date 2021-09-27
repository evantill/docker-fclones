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
	@INSTALL_BIN=$(INSTALL_BIN) ./scripts/make.sh installScript

uninstall: ## Remove docker image and wrapper script
uninstall: cleanDockerImage uninstallScript

cleanDockerImage:
ifeq "$(shell docker images | grep $(DOCKER_IMAGE_NAME) >/dev/null; echo $$?)" "0"
	docker rmi $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
endif

uninstallScript:
	@INSTALL_BIN=$(INSTALL_BIN) ./scripts/make.sh uninstallScript

clean: ## Alias for uninstall
clean: uninstall

run: ## Use ./scripts/fclones.sh to run fclones instrad of this make target
	$(error use ./scripts/fclones.sh to run fclones)

