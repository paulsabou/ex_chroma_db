# ExChromaDB client

Chroma DB exposes an HTTP REST API. The `ex_chroma_db` library provides a convenient wrapper and some caches that simplifies working with the API.

## Installation

The package can be installed by adding `ex_chroma_db` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
      {:ex_chroma_db, "0.1.0"}
  ]
end
```

after that just add the ExChromaDb child spec under your supervision tree 
```elixir
child_specs = ExChromaDb.child_specs()

# Start a supervisor to manage the cache processes
{:ok, _pid} = Supervisor.start_link(child_specs, strategy: :one_for_one)
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