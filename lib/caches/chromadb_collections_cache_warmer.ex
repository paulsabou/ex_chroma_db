defmodule ExChromaDb.Caches.ChromadbCollectionsCacheWarmer do
  @moduledoc """
  Module to warm the Collections cache.
  """
  use Cachex.Warmer

  @doc """
  Executes this cache warmer.
  """
  def execute(_) do
    # We don't need to warm the cache for now.
    :ignore
  end
end
