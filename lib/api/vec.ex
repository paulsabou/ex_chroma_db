defmodule ExChromaDb.Api.Vec do
  @moduledoc """
  Provides struct and type for a Vec
  """

  @type t :: %__MODULE__{
          database: String.t(),
          dimension: integer | nil,
          id: String.t(),
          log_position: integer,
          metadata: ExChromaDb.Api.HashMap.t() | nil,
          name: String.t(),
          tenant: String.t(),
          version: integer
        }

  defstruct [:database, :dimension, :id, :log_position, :metadata, :name, :tenant, :version]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      database: {:string, :generic},
      dimension: {:union, [:integer, :null]},
      id: {:string, :uuid},
      log_position: :integer,
      metadata: {:union, [{ExChromaDb.Api.HashMap, :t}, :null]},
      name: {:string, :generic},
      tenant: {:string, :generic},
      version: :integer
    ]
  end
end
