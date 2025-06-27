defmodule ExChromaDb.Api.GetRequestPayload do
  @moduledoc """
  Provides struct and type for a GetRequestPayload
  """

  @type t :: %__MODULE__{
          ids: [String.t()] | nil,
          include: [String.t()] | nil,
          limit: integer | nil,
          offset: integer | nil,
          where: map | nil,
          where_document: map | nil
        }

  defstruct [:ids, :include, :limit, :offset, :where, :where_document]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      ids: {:union, [[string: :generic], :null]},
      include: [enum: ["distances", "documents", "embeddings", "metadatas", "uris"]],
      limit: {:union, [:integer, :null]},
      offset: {:union, [:integer, :null]},
      where: :map,
      where_document: :map
    ]
  end
end
