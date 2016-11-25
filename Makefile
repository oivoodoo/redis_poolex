NAME = redis_poolex
NETWORK = redispoolex_back-tier

build:
	docker-compose up -d
	docker build -t $(NAME) .
	docker run --rm -t -i \
		--network=$(NETWORK) \
		-v `pwd`:/app \
		--dns 8.8.8.8 \
		-w /app \
		$(NAME) \
		/bin/bash -c "mix deps.get"
.PHONY: build

test:
	docker run --rm -t -i \
		--network=$(NETWORK) \
		-v `pwd`:/app \
		--dns 8.8.8.8 \
		-w /app \
		$(NAME) \
		/bin/bash -c "mix test"
.PHONY: test

console:
	docker run --rm -t -i \
		--network=$(NETWORK) \
		-v `pwd`:/app \
		--dns 8.8.8.8 \
		-w /app \
		$(NAME) \
		/bin/bash
.PHONY: console
