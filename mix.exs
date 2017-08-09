defmodule DatocmsClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :datocms_client,
      version: "0.2.1",
      elixir: "~> 1.4",
      name: "DatoCMS",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      source_url: "https://github.com/joeyates/elixir-datocms-client",
      homepage_url: "http://github.com/joeyates/elixir-datocms-client",
      docs: [
        main: "DatoCMS",
        extras: ["README.md", "DatoCMS-JSON-responses.md"]
      ],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:httpoison, :logger],
      mod: {DatoCMS, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:exjsx, "~> 3.2"},
      {:json_hyperschema_client_builder, "~> 0.9.1"},
      {:httpoison, "~> 0.11.1"},
      {:morphix, "~> 0.0.7"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
