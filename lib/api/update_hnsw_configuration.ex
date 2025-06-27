defmodule ExChromaDb.Api.UpdateHnswConfiguration do
  @moduledoc """
  Provides struct and type for a UpdateHnswConfiguration
  """

  @type t :: %__MODULE__{
          batch_size: integer | nil,
          ef_search: integer | nil,
          max_neighbors: integer | nil,
          num_threads: integer | nil,
          resize_factor: number | nil,
          sync_threshold: integer | nil
        }

  defstruct [
    :batch_size,
    :ef_search,
    :max_neighbors,
    :num_threads,
    :resize_factor,
    :sync_threshold
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      batch_size: {:union, [:integer, :null]},
      ef_search: {:union, [:integer, :null]},
      max_neighbors: {:union, [:integer, :null]},
      num_threads: {:union, [:integer, :null]},
      resize_factor: {:union, [:number, :null]},
      sync_threshold: {:union, [:integer, :null]}
    ]
  end
end
