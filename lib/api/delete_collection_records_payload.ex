defmodule ExChromaDb.Api.DeleteCollectionRecordsPayload do
  @moduledoc """
  Provides struct and type for a DeleteCollectionRecordsPayload
  """

  @type t :: %__MODULE__{ids: [String.t()] | nil, where: map | nil, where_document: map | nil}

  defstruct [:ids, :where, :where_document]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [ids: {:union, [[string: :generic], :null]}, where: :map, where_document: :map]
  end
end
