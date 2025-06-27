defmodule ExChromaDb.Api.CreateTenantPayload do
  @moduledoc """
  Provides struct and type for a CreateTenantPayload
  """

  @type t :: %__MODULE__{name: String.t()}

  defstruct [:name]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [name: {:string, :generic}]
  end
end
