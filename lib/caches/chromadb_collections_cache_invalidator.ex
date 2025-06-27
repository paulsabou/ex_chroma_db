defmodule ExChromaDb.Caches.ChromadbCollectionsCacheInvalidator do
  use Cachex.Hook

  @moduledoc """
    Right now we don't need to invalidate the cache.
    We need the hook as it is a gen server. The hook starts and stops with the cache so we uses it as a way to capture events from EctoWatch and invalidate the cache. \"""
  """
  def watchers() do
    []
  end

  @impl true
  def async?(), do: true

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_notify(msg, _results, _last) do
    {:ok, msg}
  end

  @impl true
  def handle_call(:last_action, _ctx, last),
    do: {:reply, last, last}
end
