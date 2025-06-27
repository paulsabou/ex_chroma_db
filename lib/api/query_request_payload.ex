defmodule ExChromaDb.Api.QueryRequestPayload do
  @moduledoc """
  Provides struct and type for a QueryRequestPayload
  """

  @type t :: %__MODULE__{
          ids: [String.t()] | nil,
          include: [String.t()] | nil,
          n_results: integer | nil,
          query_embeddings: [[number]] | nil,
          where: map | nil,
          where_document: map | nil
        }

  defstruct [:ids, :include, :n_results, :query_embeddings, :where, :where_document]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      ids: {:union, [[string: :generic], :null]},
      include: [enum: ["distances", "documents", "embeddings", "metadatas", "uris"]],
      n_results: {:union, [:integer, :null]},
      query_embeddings: [[:number]],
      where: :map,
      where_document: :map
    ]
  end
end
