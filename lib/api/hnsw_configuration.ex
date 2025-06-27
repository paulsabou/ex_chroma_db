defmodule ExChromaDb.Api.HnswConfiguration do
  @moduledoc """
  Provides struct and type for a HnswConfiguration
  """

  @type t :: %__MODULE__{
          batch_size: integer | nil,
          ef_construction: integer | nil,
          ef_search: integer | nil,
          max_neighbors: integer | nil,
          num_threads: integer | nil,
          resize_factor: number | nil,
          space: String.t() | nil,
          sync_threshold: integer | nil
        }

  defstruct [
    :batch_size,
    :ef_construction,
    :ef_search,
    :max_neighbors,
    :num_threads,
    :resize_factor,
    :space,
    :sync_threshold
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      batch_size: :integer,
      ef_construction: :integer,
      ef_search: :integer,
      max_neighbors: :integer,
      num_threads: :integer,
      resize_factor: :number,
      space: {:enum, ["l2", "cosine", "ip"]},
      sync_threshold: :integer
    ]
  end
end
