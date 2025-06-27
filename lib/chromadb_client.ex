defmodule ExChromaDb.ChromadbClient do
  @moduledoc """
  This module provides a client for the ChromaDB API.
  """

  alias ExChromaDb.Api.Operations
  alias ExChromaDb.Api.Vec
  alias ExChromaDb.Api.Collection
  alias ExChromaDb.Api.GetResponse
  alias ExChromaDb.Api.QueryResponse
  alias ExChromaDb.Types
  alias ExChromaDb.Caches.ChromadbCollectionsCache

  @default_pagination %{limit: 100, offset: 0}

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

  def get_config() do
    config = Application.fetch_env!(:ex_chroma_db, __MODULE__)

    %{
      host: Keyword.fetch!(config, :host),
      tenant_default: Keyword.fetch!(config, :tenant_default),
      database_default: Keyword.get(config, :database_default)
    }
  end

  @spec reset() :: Types.one_result(boolean())
  def reset() do
    case Operations.reset(client: __MODULE__) do
      {:ok, _} ->
        {:ok, true}

      {:error, message} ->
        {:error, message}
    end
  end

  @spec healthcheck() :: Types.one_result(boolean())
  def healthcheck() do
    with {:ok, response} <- Operations.healthcheck(client: __MODULE__),
         {:ok, _} <- assert_response_body_is_error_free(response.body),
         {:ok, body} <- Jason.decode(response.body) do
      {:ok, body["is_executor_ready"] == true}
    end
  end

  @spec heartbeat() :: Types.one_result(non_neg_integer())
  def heartbeat() do
    with {:ok, response} <- Operations.heartbeat(client: __MODULE__),
         {:ok, _} <- assert_response_body_is_error_free(response.body),
         {:ok, body} <- Jason.decode(response.body) do
      {:ok, body["nanosecond heartbeat"]}
    end
  end

  @spec version() :: Types.one_result(String.t())
  def version() do
    case Operations.version(client: __MODULE__) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec create_tenant(String.t()) :: Types.one_result(String.t())
  def create_tenant(tenant_name) do
    with {:ok, response} <-
           Operations.create_tenant(
             %{
               name: tenant_name
             },
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, tenant_name}
    end
  end

  @spec get_tenant(String.t()) :: Types.one_result(boolean())
  def get_tenant(tenant_name) do
    with {:ok, response} <- Operations.get_tenant(tenant_name, client: __MODULE__),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, true}
    end
  end

  @spec get_or_create_tenant(String.t()) :: Types.one_result(boolean())
  def get_or_create_tenant(tenant_name) do
    case get_tenant(tenant_name) do
      {:ok, _} ->
        {:ok, true}

      {:error, _} ->
        case create_tenant(tenant_name) do
          {:ok, _} -> get_tenant(tenant_name)
          {:error, error} -> {:error, error}
        end
    end
  end

  @spec create_database(database_info()) ::
          Types.one_result(String.t())
  def create_database(database_info) do
    with {:ok, response} <-
           Operations.create_database(
             database_info.tenant_name,
             %{
               name: database_info.database_name
             },
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, database_info.database_name}
    end
  end

  @spec get_database(database_info()) ::
          Types.one_result(boolean())
  def get_database(database_info) do
    with {:ok, response} <-
           Operations.get_database(
             database_info.tenant_name,
             database_info.database_name,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, true}
    end
  end

  @spec get_or_create_database(database_info()) ::
          Types.one_result(boolean())
  def get_or_create_database(database_info) do
    {:ok, true} = get_or_create_tenant(database_info.tenant_name)

    case get_database(database_info) do
      {:ok, _} ->
        {:ok, true}

      {:error, _} ->
        case create_database(database_info) do
          {:ok, _} -> get_database(database_info)
          {:error, error} -> {:error, error}
        end
    end
  end

  @spec list_databases(String.t(), pagination()) ::
          Types.list_result(Vec.t())
  def list_databases(tenant_name, pagination \\ @default_pagination) do
    with {:ok, response} <-
           Operations.list_databases(
             tenant_name,
             client: __MODULE__,
             limit: pagination.limit,
             offset: pagination.offset
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, body}
    end
  end

  @spec count_collections(database_info()) :: Types.one_result(non_neg_integer())
  def count_collections(database_info) do
    with {:ok, response} <-
           Operations.count_collections(
             database_info.tenant_name,
             database_info.database_name,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, String.to_integer(response.body)}
    end
  end

  def delete_database(database_info) do
    with {:ok, response} <-
           Operations.delete_database(
             database_info.tenant_name,
             database_info.database_name,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body),
         {:ok, _} <- ChromadbCollectionsCache.invalidate_one_database(database_info.database_name) do
      {:ok, true}
    end
  end

  @spec create_collection(collection_info()) ::
          Types.one_result(String.t())
  def create_collection(collection_info) do
    with {:ok, response} <-
           Operations.create_collection(
             collection_info.tenant_name,
             collection_info.database_name,
             %{
               get_or_create: true,
               name: collection_info.collection_name
             },
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, collection_info.collection_name}
    end
  end

  @spec get_or_create_collection(collection_info()) ::
          Types.one_result(boolean())
  def get_or_create_collection(collection_info) do
    {:ok, true} =
      get_or_create_database(%{
        tenant_name: collection_info.tenant_name,
        database_name: collection_info.database_name
      })

    case get_collection_info(collection_info) do
      {:ok, _} ->
        {:ok, true}

      {:error, _} ->
        case create_collection(collection_info) do
          {:ok, _} -> get_collection_info(collection_info)
          {:error, error} -> {:error, error}
        end
    end
  end

  @spec get_collection_info(collection_info()) ::
          Types.one_result(Collection.t())
  def get_collection_info(collection_info) do
    with {:ok, response} <-
           Operations.get_collection(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_info.collection_name,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok,
       struct(
         Collection,
         body
         |> Map.delete("configuration_json")
         |> ExChromaDb.Map.binary_keys_to_atom()
       )}
    end
  end

  @spec list_collections(database_info(), pagination()) ::
          Types.list_result(Vec.t())
  def list_collections(database_info, pagination \\ @default_pagination) do
    with {:ok, response} <-
           Operations.list_collections(
             database_info.tenant_name,
             database_info.database_name,
             client: __MODULE__,
             limit: pagination.limit,
             offset: pagination.offset
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, body}
    end
  end

  @spec delete_collection(collection_info()) :: Types.one_result(boolean())
  def delete_collection(collection_info) do
    with {:ok, response} <-
           Operations.delete_collection(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_info.collection_name,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body),
         {:ok, _} <- ChromadbCollectionsCache.invalidate_one_collection(collection_info) do
      {:ok, true}
    end
  end

  @spec collection_records_add(
          collection_info(),
          records()
        ) :: Types.one_result(boolean())
  def collection_records_add(collection_info, records) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_add(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             records,
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, true}
    end
  end

  @spec collection_records_count(collection_info()) :: Types.one_result(non_neg_integer())
  def collection_records_count(collection_info) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_count(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             client: __MODULE__
           ),
         {:ok, body} <- Jason.decode(response.body),
         {:ok, _} <- assert_response_body_is_error_free(body) do
      {:ok, String.to_integer(response.body)}
    end
  end

  @spec collection_records_delete(collection_info(), %{
          ids: list(record_id()) | nil,
          where: map() | nil,
          where_document: map() | nil
        }) ::
          Types.one_result(boolean())
  def collection_records_delete(collection_info, delete_criteria) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_delete(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             delete_criteria,
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, true}
    end
  end

  @spec collection_records_get(
          collection_info(),
          %{
            include: list(String.t()) | nil,
            ids: list(record_id()) | nil,
            where: map() | nil,
            where_document: map() | nil
          },
          pagination()
        ) ::
          Types.one_result(GetResponse.t())
  def collection_records_get(collection_info, get_criteria, pagination \\ @default_pagination) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_get(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             get_criteria,
             client: __MODULE__,
             limit: pagination.limit,
             offset: pagination.offset
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok,
       struct(
         GetResponse,
         response.body
         |> ExChromaDb.Map.binary_keys_to_atom()
       )}
    end
  end

  @spec collection_records_query(
          collection_info(),
          %{
            include: list(String.t()) | nil,
            ids: list(record_id()) | nil,
            where: map() | nil,
            where_document: map() | nil,
            query_embeddings: list(document_embedding()) | nil,
            query_texts: list(String.t()) | nil,
            n_results: integer | nil
          }
        ) ::
          Types.one_result(QueryResponse.t())
  def collection_records_query(collection_info, query_criteria) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_query(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             query_criteria,
             client: __MODULE__
           ),
         {:ok, _} <-
           assert_response_body_is_error_free(response.body) do
      {:ok,
       struct(
         QueryResponse,
         response.body
         |> ExChromaDb.Map.binary_keys_to_atom()
       )}
    end
  end

  @spec collection_records_upsert(
          collection_info(),
          records()
        ) ::
          Types.one_result(boolean())
  def collection_records_upsert(collection_info, update_data) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_upsert(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             update_data,
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, true}
    end
  end

  @spec collection_records_update(
          collection_info(),
          records()
        ) ::
          Types.one_result(boolean())
  def collection_records_update(collection_info, update_data) do
    with {:ok, collection_meta_info} <-
           ChromadbCollectionsCache.get_one_collection(collection_info),
         {:ok, response} <-
           Operations.collection_update(
             collection_info.tenant_name,
             collection_info.database_name,
             collection_meta_info.id,
             update_data,
             client: __MODULE__
           ),
         {:ok, _} <- assert_response_body_is_error_free(response.body) do
      {:ok, true}
    end
  end

  @spec collection_records_delete_by_ids(collection_info(), list(record_id())) ::
          Types.one_result(boolean())
  def collection_records_delete_by_ids(collection_info, record_ids_to_delete) do
    collection_records_delete(collection_info, %{
      ids: record_ids_to_delete,
      where: nil,
      where_document: nil
    })
  end

  @spec collection_records_delete_by_metas(collection_info(), map()) ::
          Types.one_result(boolean())
  def collection_records_delete_by_metas(collection_info, record_metas_to_delete) do
    collection_records_delete(collection_info, %{
      ids: nil,
      where: record_metas_to_delete,
      where_document: nil
    })
  end

  def request(request) do
    case request.method do
      :get ->
        Tesla.get(client(), request.url, [])

      :post ->
        request_body = if is_nil(request[:body]), do: [], else: request.body
        Tesla.post(post_client(), request.url, request_body, [])

      :put ->
        nil

      :delete ->
        Tesla.delete(client(), request.url, [])
    end
  end

  defp post_client do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_config()[:host]},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]}
    ]

    Tesla.client(middleware, adapter())
  end

  defp client do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_config()[:host]}
    ]

    Tesla.client(middleware, adapter())
  end

  defp adapter() do
    Application.fetch_env!(:tesla, :adapter)
  end

  defp assert_response_body_is_error_free(body) do
    case body do
      %{"error" => error, "message" => message} when not is_nil(error) ->
        {:error, "#{error} - #{message}"}

      _ ->
        {:ok, body}
    end
  end

  def build_metadata_where_and_equality(metadata) do
    %{
      "$and":
        Enum.map(metadata, fn {key, value} ->
          %{
            key => %{
              "$eq": value
            }
          }
        end)
    }
  end
end
