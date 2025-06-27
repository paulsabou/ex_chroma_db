defmodule ExChromaDb.Api.UpdateCollectionPayload do
  @moduledoc """
  Provides struct and type for a UpdateCollectionPayload
  """

  @type t :: %__MODULE__{
          new_configuration: ExChromaDb.Api.UpdateCollectionConfiguration.t() | nil,
          new_metadata: ExChromaDb.Api.HashMap.t() | nil,
          new_name: String.t() | nil
        }

  defstruct [:new_configuration, :new_metadata, :new_name]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      new_configuration: {:union, [{ExChromaDb.Api.UpdateCollectionConfiguration, :t}, :null]},
      new_metadata: {:union, [{ExChromaDb.Api.HashMap, :t}, :null]},
      new_name: {:union, [{:string, :generic}, :null]}
    ]
  end
end
