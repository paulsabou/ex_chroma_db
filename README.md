# ExChromaDB client

## Installation

The package can be installed by adding `ex_chroma_db` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
      {:ex_chroma_db, "0.1.0"}
  ]
end
```

## Library maintainer guide

# Running the tests

1. Start associated dockers
`cd deployment && docker compose up --build`

2. Run the test suite
`mix test`

# Regenerate the chroma client based on open api specs
`mix chromadb.generate`

## Documentation
Documentation can be be found at <https://hexdocs.pm/ex_chroma_db>.