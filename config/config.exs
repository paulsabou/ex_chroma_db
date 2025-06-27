# config/config.exs

import Config

# Configure the ChromaDB client generator
config :oapi_generator,
  chromadb_client: [
    output: [
      base_module: ExChromaDb.Api,
      location: "lib/api"
    ]
  ]

# Configure the ChromaDB client
config :ex_chroma_db, ExChromaDb,
  host: "http://localhost:8000",
  tenant_default: "exchroma",
  database_default: "exchroma_default"

# Configure Tesla HTTP client
config :tesla, adapter: Tesla.Adapter.Hackney
