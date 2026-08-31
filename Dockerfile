FROM elixir:1.17.3-otp-27-alpine

RUN apk add --no-cache git build-base

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=test
