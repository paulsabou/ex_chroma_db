defmodule ExChromaDb.MixProject do
  use Mix.Project

  @version "0.1.0"

  @description "Elixir ChromaDB library"
  @repo_url "https://github.com/paulsabou/ex_chroma_db"

  def project do
    [
      app: :ex_chroma_db,
      version: @version,
      elixir: "~> 1.17",
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: [:mix],
        ignore_warnings: ".dialyzer_ignore.exs"
      ],

      # Hex
      package: hex_package(),
      description: @description,

      # Docs
      name: "ex_chroma_db",
      docs: [
        source_ref: "v#{@version}",
        main: "ExChromaDb",
        source_url: @repo_url
        # extras: ["CHANGELOG.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :telemetry, :hackney]
    ]
  end

  def hex_package do
    [
      maintainers: ["Paul Sabou"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @repo_url,
        "Changelog" => @repo_url <> "/blob/main/CHANGELOG.md"
      },
      files: ~w(lib mix.exs *.md)
    ]
  end

  defp deps do
    [
      # BEGIN --------------------------------- App core
      # Caching for chromadb collections
      {:cachex, "~> 4.0.3"},
      # We generate the ChromaDB client from the OpenAPI spec
      {:oapi_generator, "~> 0.2.0", only: :dev, runtime: false},
      # HTTP Cient
      {:tesla, "~> 1.5"},
      # HTTP adapter for Tesla
      {:hackney, "~> 1.18", runtime: true},
      # UUID generation for tests
      {:uuid, "~> 1.1", only: [:dev, :test], runtime: false},
      # END --------------------------------- App core

      # BEGIN --------------------------------- Developer Experience
      # Types annotations checks
      {:dialyxir, "~> 1.4", runtime: false},
      # Code style checker
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # Security checks
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      # Code documentation
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      # Deps security audits
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      # Watch code changes & rerun tests automatically
      {:mix_test_watch, "~> 1.2.0", only: [:dev, :test], runtime: false},
      # Test factories
      {:ex_machina, "~> 2.8.0", only: :test},
      # Tidewave - LLM API MCP
      {:tidewave, "~> 0.1", only: [:dev, :test], runtime: false}
      # END --------------------------------- Developer Experience
    ]
  end

  defp aliases do
    [
      test: ["test"],
      sobelow: ["sobelow --config .sobelow-conf"],
      prepare_commit: [
        "credo",
        "sobelow",
        "hex.audit",
        "deps.audit",
        "deps.unlock --check-unused",
        "format",
        "dialyzer"
      ],
      "chromadb.generate": ["api.gen chromadb_client priv/openapi/chromadb.openapi.json"]
    ]
  end
end
