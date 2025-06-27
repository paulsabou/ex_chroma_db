defmodule ExChromaDb.Api.AddCollectionRecordsPayload do
  @moduledoc """
  Provides struct and type for a AddCollectionRecordsPayload
  """

  @type t :: %__MODULE__{
          documents: [String.t() | nil] | nil,
          embeddings: [[number]] | nil,
          ids: [String.t()],
          metadatas: [ExChromaDb.Api.HashMap.t() | nil] | nil,
          uris: [String.t() | nil] | nil
        }

  defstruct [:documents, :embeddings, :ids, :metadatas, :uris]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      documents: {:union, [[union: [{:string, :generic}, :null]], :null]},
      embeddings: {:union, [[[:number]], :null]},
      ids: [string: :generic],
      metadatas: {:union, [[union: [{ExChromaDb.Api.HashMap, :t}, :null]], :null]},
      uris: {:union, [[union: [{:string, :generic}, :null]], :null]}
    ]
  end
end
