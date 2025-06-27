defmodule ExChromaDb.Caches.ChromadbCollectionsCache do
  @moduledoc """
    Collections cache.
  """

  alias ExChromaDb.Types
  alias ExChromaDb.Api.Collection

  import Cachex.Spec

  # Cache configuration
  @cache_invalidator_hook_name :cache_chromadb_collections_invalidator

  @cache_name :cache_chromadb_collections

  @cache_max_size 1_000_000

  # Final fallback in case invalidation fails
  @cache_max_lifespan_in_mins 1_000_000

  def config_cache_invalidator_watchers() do
    []
  end

  def config_cache_supervision_child_specs() do
    [
      Supervisor.child_spec(
        {
          Cachex,
          [
            @cache_name,
            [
              warmers: [
                warmer(
                  state: %{},
                  module: ExChromaDb.Caches.ChromadbCollectionsCacheWarmer,
                  interval: :timer.minutes(@cache_max_lifespan_in_mins),
                  required: true
                )
              ],
              hooks: [
                hook(module: Cachex.Stats),
                hook(
                  module: Cachex.Limit.Scheduled,
                  args: {
                    # setting cache max size
                    @cache_max_size,
                    # options for `Cachex.prune/3`
                    [],
                    # options for `Cachex.Limit.Scheduled`
                    []
                  }
                ),
                hook(
                  module: ExChromaDb.Caches.ChromadbCollectionsCacheInvalidator,
                  name: @cache_invalidator_hook_name
                )
              ],
              stats: true
            ]
          ]
        },
        id: @cache_name
      )
    ]
  end

  defp cache_key_components(cache_key) do
    [tenant_name, database_name, collection_name] = String.split(cache_key, "/")

    %{
      tenant_name: tenant_name,
      database_name: database_name,
      collection_name: collection_name
    }
  end

  defp cache_key(collection_info),
    do:
      "#{collection_info.tenant_name}/#{collection_info.database_name}/#{collection_info.collection_name}"

  @spec get_one_collection(Types.collection_info()) :: Types.one_result(Collection.t())
  def get_one_collection(collection_info) do
    key = cache_key(collection_info)

    case Cachex.get(@cache_name, key) do
      {:ok, nil} ->
        maybe_compute_and_store_one_collection(collection_info)

      {:ok, value} ->
        {:ok, value}
    end
  end

  @spec invalidate_one_database(String.t()) :: {:ok, boolean()}
  def invalidate_one_database(database_name) do
    {:ok, keys} = Cachex.keys(@cache_name)

    Enum.each(keys, fn key ->
      if cache_key_components(key).database_name == database_name do
        Cachex.del(@cache_name, key)
      end
    end)

    {:ok, true}
  end

  @spec invalidate_one_collection(Types.collection_info()) :: {:ok, boolean() | nil}
  def invalidate_one_collection(collection_info) do
    Cachex.del(@cache_name, cache_key(collection_info))
  end

  defp maybe_compute_and_store_one_collection(collection_info) do
    with {:ok, _response} <- ExChromaDb.get_or_create_collection(collection_info),
         {:ok, collection} <- ExChromaDb.get_collection_info(collection_info),
         key <- cache_key(collection_info),
         {:ok, true} <- Cachex.put(@cache_name, key, collection) do
      {:ok, collection}
    end
  end
end
