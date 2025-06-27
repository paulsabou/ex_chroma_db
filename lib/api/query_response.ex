defmodule ExChromaDb.Api.QueryResponse do
  @moduledoc """
  Provides struct and type for a QueryResponse
  """

  @type t :: %__MODULE__{
          distances: [[number | nil]] | nil,
          documents: [[String.t() | nil]] | nil,
          embeddings: [[[number] | nil]] | nil,
          ids: [[String.t()]],
          include: [String.t()],
          metadatas: [[ExChromaDb.Api.HashMap.t() | nil]] | nil,
          uris: [[String.t() | nil]] | nil
        }

  defstruct [:distances, :documents, :embeddings, :ids, :include, :metadatas, :uris]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      distances: {:union, [[[union: [:number, :null]]], :null]},
      documents: {:union, [[[union: [{:string, :generic}, :null]]], :null]},
      embeddings: {:union, [[[union: [[:number], :null]]], :null]},
      ids: [[string: :generic]],
      include: [enum: ["distances", "documents", "embeddings", "metadatas", "uris"]],
      metadatas: {:union, [[[union: [{ExChromaDb.Api.HashMap, :t}, :null]]], :null]},
      uris: {:union, [[[union: [{:string, :generic}, :null]]], :null]}
    ]
  end
end
