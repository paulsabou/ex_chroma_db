defmodule ExChromaDb.Api.ChecklistResponse do
  @moduledoc """
  Provides struct and type for a ChecklistResponse
  """

  @type t :: %__MODULE__{max_batch_size: integer}

  defstruct [:max_batch_size]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [max_batch_size: :integer]
  end
end
