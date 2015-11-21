defmodule RedisPoolex.Mixfile do
  use Mix.Project

  def project do
    [app: :redis_poolex,
     version: "0.0.1",
     elixir: "~> 1.2-dev",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger],
      mod: {RedisPoolex, []}
    ]
  end

  defp description do
    """
    Redis connection pool using poolboy and exredis libraries
    """
  end

  defp package do
    [# These are the default files included in the package
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Alexandr Korsak"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/oivoodoo/redis_poolex",
        "Docs" => "http://oivoodoo.github.io/redis_poolex/"
      }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poolboy, github: "devinus/poolboy"},
      {:exredis, ">= 0.2.2"}
    ]
  end
end
