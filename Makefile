.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / \
		{printf "\033[38;2;98;209;150m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

export
NOW = $(shell date '+%Y%m%d-%H%M%S')

#######################################################################################################################
# pypiserver
#######################################################################################################################
IMAGE_NAME = imokuri123/pypiserver
IMAGE_TAG = v0.0.2

build-pypiserver: ## Build pypiserver.
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) -f Dockerfile .

push-pypiserver: ## Push pypiserver.
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

run-pypiserver: ## Run shell in pypiserver.
	docker run -it --rm \
		--shm-size=16g \
		-v $(shell pwd):/work \
		-w /work \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		sh

up-pypiserver: ## Start pypiserver.
	docker run -d --name pypiserver -p 8080:8080 \
		--shm-size=16g \
		-v $(XDG_CACHE_HOME):/root/.cache \
		$(IMAGE_NAME):$(IMAGE_TAG)

down-pypiserver: ## Stop pypiserver.
	docker stop pypiserver || :
	docker rm pypiserver || :

ps-pypiserver: ## Status pypiserver.
	docker ps -a -f name=pypiserver || :

log-pypiserver: ## Log pypiserver.
	docker logs -f pypiserver || :



