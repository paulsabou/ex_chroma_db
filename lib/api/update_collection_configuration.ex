defmodule ExChromaDb.Api.UpdateCollectionConfiguration do
  @moduledoc """
  Provides struct and type for a UpdateCollectionConfiguration
  """

  @type t :: %__MODULE__{
          embedding_function: map | nil,
          hnsw: ExChromaDb.Api.UpdateHnswConfiguration.t() | nil,
          spann: ExChromaDb.Api.SpannConfiguration.t() | nil
        }

  defstruct [:embedding_function, :hnsw, :spann]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      embedding_function: {:union, [:map, :null]},
      hnsw: {:union, [{ExChromaDb.Api.UpdateHnswConfiguration, :t}, :null]},
      spann: {:union, [{ExChromaDb.Api.SpannConfiguration, :t}, :null]}
    ]
  end
end
