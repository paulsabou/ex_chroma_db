defmodule ExChromaDb.Api.ErrorResponse do
  @moduledoc """
  Provides struct and type for a ErrorResponse
  """

  @type t :: %__MODULE__{error: String.t(), message: String.t()}

  defstruct [:error, :message]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [error: {:string, :generic}, message: {:string, :generic}]
  end
end
