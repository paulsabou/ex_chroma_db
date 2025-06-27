defmodule ExChromaDb.Api.CreateCollectionPayload do
  @moduledoc """
  Provides struct and type for a CreateCollectionPayload
  """

  @type t :: %__MODULE__{
          configuration: ExChromaDb.Api.CollectionConfiguration.t() | nil,
          get_or_create: boolean | nil,
          metadata: ExChromaDb.Api.HashMap.t() | nil,
          name: String.t()
        }

  defstruct [:configuration, :get_or_create, :metadata, :name]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      configuration: {:union, [{ExChromaDb.Api.CollectionConfiguration, :t}, :null]},
      get_or_create: :boolean,
      metadata: {:union, [{ExChromaDb.Api.HashMap, :t}, :null]},
      name: {:string, :generic}
    ]
  end
end
