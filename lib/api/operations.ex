defmodule ExChromaDb.Api.Operations do
  @moduledoc """
  Provides API endpoints related to operations
  """

  @default_client ExChromaDb.Api.Client

  @doc """
  Adds records to a collection.
  """
  @spec collection_add(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.AddCollectionRecordsPayload.t(),
          keyword
        ) :: {:ok, map} | :error
  def collection_add(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_add},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/add",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.AddCollectionRecordsPayload, :t}}],
      response: [{201, :map}, {400, :null}],
      opts: opts
    })
  end

  @doc """
  Retrieves the number of records in a collection.
  """
  @spec collection_count(String.t(), String.t(), String.t(), keyword) ::
          {:ok, integer} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def collection_count(tenant, database, collection_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id],
      call: {ExChromaDb.Api.Operations, :collection_count},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/count",
      method: :get,
      response: [
        {200, :integer},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Deletes records in a collection. Can filter by IDs or metadata.
  """
  @spec collection_delete(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.DeleteCollectionRecordsPayload.t(),
          keyword
        ) :: {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def collection_delete(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_delete},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/delete",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.DeleteCollectionRecordsPayload, :t}}],
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves records from a collection by ID or metadata filter.
  """
  @spec collection_get(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.GetRequestPayload.t(),
          keyword
        ) :: {:ok, ExChromaDb.Api.GetResponse.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def collection_get(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_get},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/get",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.GetRequestPayload, :t}}],
      response: [
        {200, {ExChromaDb.Api.GetResponse, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Query a collection in a variety of ways, including vector search, metadata filtering, and full-text search

  ## Options

    * `limit`: Limit for pagination
    * `offset`: Offset for pagination

  """
  @spec collection_query(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.QueryRequestPayload.t(),
          keyword
        ) :: {:ok, ExChromaDb.Api.QueryResponse.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def collection_query(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_query},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/query",
      body: body,
      method: :post,
      query: query,
      request: [{"application/json", {ExChromaDb.Api.QueryRequestPayload, :t}}],
      response: [
        {200, {ExChromaDb.Api.QueryResponse, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Updates records in a collection by ID.
  """
  @spec collection_update(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.UpdateCollectionRecordsPayload.t(),
          keyword
        ) :: {:ok, map} | :error
  def collection_update(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_update},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/update",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.UpdateCollectionRecordsPayload, :t}}],
      response: [{200, :map}, {404, :null}],
      opts: opts
    })
  end

  @doc """
  Upserts records in a collection (create if not exists, otherwise update).
  """
  @spec collection_upsert(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.UpsertCollectionRecordsPayload.t(),
          keyword
        ) :: {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def collection_upsert(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :collection_upsert},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}/upsert",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.UpsertCollectionRecordsPayload, :t}}],
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves the total number of collections in a given database.
  """
  @spec count_collections(String.t(), String.t(), keyword) ::
          {:ok, integer} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def count_collections(tenant, database, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database],
      call: {ExChromaDb.Api.Operations, :count_collections},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections_count",
      method: :get,
      response: [
        {200, :integer},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Creates a new collection under the specified database.
  """
  @spec create_collection(
          String.t(),
          String.t(),
          ExChromaDb.Api.CreateCollectionPayload.t(),
          keyword
        ) :: {:ok, ExChromaDb.Api.Collection.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def create_collection(tenant, database, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, body: body],
      call: {ExChromaDb.Api.Operations, :create_collection},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.CreateCollectionPayload, :t}}],
      response: [
        {200, {ExChromaDb.Api.Collection, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Creates a new database for a given tenant.
  """
  @spec create_database(String.t(), ExChromaDb.Api.CreateDatabasePayload.t(), keyword) ::
          {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def create_database(tenant, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, body: body],
      call: {ExChromaDb.Api.Operations, :create_database},
      url: "/api/v2/tenants/#{tenant}/databases",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.CreateDatabasePayload, :t}}],
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Creates a new tenant.
  """
  @spec create_tenant(ExChromaDb.Api.CreateTenantPayload.t(), keyword) ::
          {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def create_tenant(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {ExChromaDb.Api.Operations, :create_tenant},
      url: "/api/v2/tenants",
      body: body,
      method: :post,
      request: [{"application/json", {ExChromaDb.Api.CreateTenantPayload, :t}}],
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Deletes a collection in a given database.
  """
  @spec delete_collection(String.t(), String.t(), String.t(), keyword) ::
          {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def delete_collection(tenant, database, collection_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id],
      call: {ExChromaDb.Api.Operations, :delete_collection},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}",
      method: :delete,
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Deletes a specific database.
  """
  @spec delete_database(String.t(), String.t(), keyword) ::
          {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def delete_database(tenant, database, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database],
      call: {ExChromaDb.Api.Operations, :delete_database},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}",
      method: :delete,
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves a collection by ID or name.
  """
  @spec get_collection(String.t(), String.t(), String.t(), keyword) ::
          {:ok, ExChromaDb.Api.Collection.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def get_collection(tenant, database, collection_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id],
      call: {ExChromaDb.Api.Operations, :get_collection},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.Collection, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves a specific database by name.
  """
  @spec get_database(String.t(), String.t(), keyword) ::
          {:ok, ExChromaDb.Api.Database.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def get_database(tenant, database, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database],
      call: {ExChromaDb.Api.Operations, :get_database},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.Database, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Returns an existing tenant by name.
  """
  @spec get_tenant(String.t(), keyword) ::
          {:ok, ExChromaDb.Api.GetTenantResponse.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def get_tenant(tenant_name, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant_name: tenant_name],
      call: {ExChromaDb.Api.Operations, :get_tenant},
      url: "/api/v2/tenants/#{tenant_name}",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.GetTenantResponse, :t}},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Retrieves the current user's identity, tenant, and databases.
  """
  @spec get_user_identity(keyword) ::
          {:ok, ExChromaDb.Api.GetUserIdentityResponse.t()}
          | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def get_user_identity(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :get_user_identity},
      url: "/api/v2/auth/identity",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.GetUserIdentityResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Health check endpoint that returns 200 if the server and executor are ready
  """
  @spec healthcheck(keyword) :: {:ok, String.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def healthcheck(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :healthcheck},
      url: "/api/v2/healthcheck",
      method: :get,
      response: [{200, {:string, :generic}}, {503, {ExChromaDb.Api.ErrorResponse, :t}}],
      opts: opts
    })
  end

  @doc """
  Heartbeat endpoint that returns a nanosecond timestamp of the current time.
  """
  @spec heartbeat(keyword) ::
          {:ok, ExChromaDb.Api.HeartbeatResponse.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def heartbeat(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :heartbeat},
      url: "/api/v2/heartbeat",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.HeartbeatResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Lists all collections in the specified database.

  ## Options

    * `limit`: Limit for pagination
    * `offset`: Offset for pagination

  """
  @spec list_collections(String.t(), String.t(), keyword) ::
          {:ok, [ExChromaDb.Api.Vec.t()]} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def list_collections(tenant, database, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [tenant: tenant, database: database],
      call: {ExChromaDb.Api.Operations, :list_collections},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections",
      method: :get,
      query: query,
      response: [
        {200, [{ExChromaDb.Api.Vec, :t}]},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Lists all databases for a given tenant.

  ## Options

    * `limit`: Limit for pagination
    * `offset`: Offset for pagination

  """
  @spec list_databases(String.t(), keyword) ::
          {:ok, [ExChromaDb.Api.Vec.t()]} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def list_databases(tenant, opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:limit, :offset])

    client.request(%{
      args: [tenant: tenant],
      call: {ExChromaDb.Api.Operations, :list_databases},
      url: "/api/v2/tenants/#{tenant}/databases",
      method: :get,
      query: query,
      response: [
        {200, [{ExChromaDb.Api.Vec, :t}]},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Pre-flight checks endpoint reporting basic readiness info.
  """
  @spec pre_flight_checks(keyword) ::
          {:ok, ExChromaDb.Api.ChecklistResponse.t()} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def pre_flight_checks(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :pre_flight_checks},
      url: "/api/v2/pre-flight-checks",
      method: :get,
      response: [
        {200, {ExChromaDb.Api.ChecklistResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Reset endpoint allowing authorized users to reset the database.
  """
  @spec reset(keyword) :: {:ok, boolean} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def reset(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :reset},
      url: "/api/v2/reset",
      method: :post,
      response: [
        {200, :boolean},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Updates an existing collection's name or metadata.
  """
  @spec update_collection(
          String.t(),
          String.t(),
          String.t(),
          ExChromaDb.Api.UpdateCollectionPayload.t(),
          keyword
        ) :: {:ok, map} | {:error, ExChromaDb.Api.ErrorResponse.t()}
  def update_collection(tenant, database, collection_id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [tenant: tenant, database: database, collection_id: collection_id, body: body],
      call: {ExChromaDb.Api.Operations, :update_collection},
      url: "/api/v2/tenants/#{tenant}/databases/#{database}/collections/#{collection_id}",
      body: body,
      method: :put,
      request: [{"application/json", {ExChromaDb.Api.UpdateCollectionPayload, :t}}],
      response: [
        {200, :map},
        {401, {ExChromaDb.Api.ErrorResponse, :t}},
        {404, {ExChromaDb.Api.ErrorResponse, :t}},
        {500, {ExChromaDb.Api.ErrorResponse, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Returns the version of the server.
  """
  @spec version(keyword) :: {:ok, String.t()} | :error
  def version(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExChromaDb.Api.Operations, :version},
      url: "/api/v2/version",
      method: :get,
      response: [{200, {:string, :generic}}],
      opts: opts
    })
  end
end
