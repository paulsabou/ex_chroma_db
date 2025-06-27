# config/config.exs

import Config

# Configure the ChromaDB client generator (only in dev environment)
if Mix.env() == :dev do
  config :oapi_generator,
    chromadb_client: [
      output: [
        base_module: ExChromaDb.Api,
        location: "lib/api"
      ]
    ]
end

# Configure the ChromaDB client
config :ex_chroma_db, ExChromaDb,
  host: "http://localhost:8000",
  tenant_default: "exchroma",
  database_default: "exchroma_default"

# Configure Tesla HTTP client
config :tesla, adapter: Tesla.Adapter.Hackney
