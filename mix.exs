defmodule Elaxtic.Mixfile do
  use Mix.Project

  def project do
    [app: :elaxtic,
     version: "0.0.1",
     elixir: "~> 1.2",
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
    [applications: [:logger, :httpoison]]
  end


  defp package do
    [files: ["lib", "mix.exs", "README*"],
     maintainers: ["Victor Borja"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/vic/elaxtic"}]
  end

  def description do
    """
    ElasticSearch client for Elixir and Ecto driver.
    """
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
    {:httpoison, "~> 0.8.0"},
    {:mix_test_watch, "~> 0.2", only: :dev},
    {:credo, "~> 0.1.9", only: [:dev, :test]},
    ]
  end
end
