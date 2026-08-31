# Changelog

## [0.1.0] - 2026-08-31

### Breaking changes

- Requires Elixir 1.15 or later.
- Replaces [exredis](https://hex.pm/packages/exredis) with [Redix](https://hex.pm/packages/redix).
- Missing Redis keys now return `nil` instead of `:undefined`.
- Redis and connection errors raise (`Redix.Error` / `Redix.ConnectionError`) instead of returning Erlang-style values.
- `HSET` and other integer Redis replies are integers, not binaries.

### Changed

- Supervisors use child specs (`Supervisor.init/2`) instead of the deprecated `Supervisor.Spec`.
- Application startup uses `extra_applications` instead of the deprecated `:applications` list.
- Pool workers are Redix connections managed by poolboy. Redix handles reconnection.
- Configuration uses `Config` instead of deprecated `Mix.Config`.
- Checkout and command timeouts both honor `:timeout` (default 5_000 ms).

### Added

- GitHub Actions CI with Redis, Elixir 1.15/OTP 26 and Elixir 1.17/OTP 27.
- Dependabot for Hex and GitHub Actions.
- `LICENSE`, `.formatter.exs`, and this changelog.

### Removed

- `RedisPoolex.Worker` GenServer wrapper around exredis.
- Manual `Process.alive?/1` reconnect logic (Redix reconnects on its own).
