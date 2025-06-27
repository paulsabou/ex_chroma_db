# config/test.exs

import Config

config :ex_chroma_db, ExChromaDb.ChromadbClient,
  host: "http://localhost:8000",
  tenant_default: "exchroma",
  database_default: "exchroma_test"

config :mix_test_watch,
  clear: true,
  tasks: [
    "test"
  ]
