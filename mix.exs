defmodule DatocmsClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :datocms_client,
      version: "0.1.0",
      elixir: "~> 1.4",
      name: "DatoCMS",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:httpoison, :logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:exjsx, "~> 3.2"},
      {:json_hyperschema_client_builder, "~> 0.9.0"},
      {:httpoison, "~> 0.11.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
