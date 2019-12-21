defmodule DatocmsClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :datocms_client,
      version: "0.2.4",
      elixir: "~> 1.4",
      name: "DatoCMS client",
      description: "DatoCMS client with helpers for static site generators",
      package: package(),
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
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:exjsx, "~> 3.2"},
      {:fermo_helpers, "~> 0.1.0", git: "https://github.com/leanpanda-com/fermo_helpers.git"},
      {:json_hyperschema_client_builder, "~> 0.9.1"},
      {:httpoison, "~> 0.11.1"},
      {:memoize, "~> 1.3"},
      {:morphix, "~> 0.0.7"}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/joeyates/elixir-datocms-client"
      },
      maintainers: ["Joe Yates"]
    }
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
