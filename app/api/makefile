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

all: ## Stop, Build, Start and Status
	docker container rm -f $(APP_IMAGE) 2>/dev/null || true
	docker image build --force-rm --network host -t go-live/$(APP_IMAGE):$(APP_VERSION) .
	docker container run -dti --env-file=./$(cnf) --name=$(APP_IMAGE) --label app=backend --restart=always --publish $(APP_PORT):8080 go-live/$(APP_IMAGE):$(APP_VERSION)
	docker container ls -f name=$(APP_IMAGE)