defmodule ExChromaDb.Types do
  @moduledoc """
  A module that provides some useful types for working with the Chroma DB API.
  """

  @type embedding_vector() :: list(float())

  @type one_result(t) :: {:ok, t} | {:error, any()}
  @type list_result(t) :: {:ok, list(t)} | {:error, any()}

  @type collection_id() :: String.t()
  @type pagination() :: %{limit: non_neg_integer(), offset: non_neg_integer()}

  @type document() :: String.t()
  @type document_embedding() :: list(number)

  @type id() :: String.t()
  @type document_metadata() :: map()
  @type uri() :: String.t()

  @type record_id() :: String.t()

  @type database_info() :: %{
          tenant_name: String.t(),
          database_name: String.t()
        }

  @type collection_info() :: %{
          tenant_name: String.t(),
          database_name: String.t(),
          collection_name: String.t()
        }

  @type collection_meta_info() :: %{
          tenant_name: String.t(),
          database_name: String.t(),
          collection_id: collection_id()
        }

  @type records() :: %{
          ids: list(record_id()),
          embeddings: list(document_embedding()),
          metadatas: list(document_metadata()),
          documents: list(document()),
          uris: list(uri())
        }
end
