defmodule ExChromaDb.Api.GetUserIdentityResponse do
  @moduledoc """
  Provides struct and type for a GetUserIdentityResponse
  """

  @type t :: %__MODULE__{databases: [String.t()], tenant: String.t(), user_id: String.t()}

  defstruct [:databases, :tenant, :user_id]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [databases: [string: :generic], tenant: {:string, :generic}, user_id: {:string, :generic}]
  end
end
