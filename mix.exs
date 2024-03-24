defmodule Shin.MixProject do
  use Mix.Project

  @source_url "https://github.com/LauraBeatris/shin"
  @version "1.0.0"

  def project do
    [
      app: :shin_auth,
      description: description(),
      package: package(),
      docs: docs(),
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    """
    Lightweight auth utilities for Elixir
    """
  end

  defp package do
    [
      maintainers: ["Laura Beatris"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "ShinAuth",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/shin_auth",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:ex_spec, "~> 2.0", only: :test},
      {:mox, "~> 1.0", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.0"},
      {:poison, "~> 5.0"},
      {:data_schema, "~> 0.5.0"},
      {:sweet_xml, "~> 0.7.4"}
    ]
  end
end
