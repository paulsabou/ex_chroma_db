defmodule ExChromaDb.Api.Database do
  @moduledoc """
  Provides struct and type for a Database
  """

  @type t :: %__MODULE__{id: String.t(), name: String.t(), tenant: String.t()}

  defstruct [:id, :name, :tenant]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [id: {:string, :uuid}, name: {:string, :generic}, tenant: {:string, :generic}]
  end
end
