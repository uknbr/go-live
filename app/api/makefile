# Change the default config with `make cnf="custom.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.PHONY: help

help: ## Display help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[35m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

run: ## Run Go main
	go run main.go

build: ## Build the container
	docker image build --force-rm --network host -t go-live/$(APP_IMAGE):$(APP_VERSION) .

start: ## Run container based on `config.env`
	docker container run -dti --env-file=./$(cnf) --name=$(APP_IMAGE) --label app=backend --restart=always --publish $(APP_PORT):8080 go-live/$(APP_IMAGE):$(APP_VERSION)

stop: ## Stop and remove a running container
	docker container rm -f $(APP_IMAGE) 2>/dev/null || true

status: ## Check status of container
	docker container ls -f name=$(APP_IMAGE)

sh: ## Access running container
	docker exec -ti $(APP_IMAGE) sh

log: ## Follow the logs
	docker logs -f $(APP_IMAGE)

restart: stop build start status ## Alias to stop, build, start and status

version: ## Output the current version
	@echo "$(APP_IMAGE):$(APP_VERSION)"