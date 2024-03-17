defmodule Shin.MixProject do
  use Mix.Project

  def project do
    [
      app: :shin_auth,
      description: description(),
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    ~S"""
    Lightweight auth utilities for Elixir
    """
  end

  defp package do
    [
      maintainers: ["Laura Beatris"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/LauraBeatris/shin"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
