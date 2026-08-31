defmodule RedisPoolex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/oivoodoo/redis_poolex"

  def project do
    [
      app: :redis_poolex,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @source_url,
      homepage_url: @source_url,
      name: "RedisPoolex"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RedisPoolex.Application, []}
    ]
  end

  defp description do
    "Redis connection pool using poolboy and Redix"
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE),
      maintainers: ["Alexandr Korsak"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md",
        "Docs" => "https://hexdocs.pm/redis_poolex/"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:redix, "~> 1.5"},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end
end
