# config/test.exs

import Config

# Configure the ChromaDB client
config :ex_chroma_db, ExChromaDb,
  host: "http://localhost:8000",
  tenant_default: "exchroma",
  database_default: "exchroma_default"

# Configure Tesla HTTP client
config :tesla, adapter: Tesla.Adapter.Hackney

config :mix_test_watch,
  clear: true,
  tasks: [
    "test"
  ]
