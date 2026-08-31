.PHONY: build test console

build:
	docker compose build
	docker compose run --rm app mix deps.get

test:
	docker compose run --rm app mix test

console:
	docker compose run --rm --entrypoint /bin/sh app
