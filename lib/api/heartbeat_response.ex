defmodule ExChromaDb.Api.HeartbeatResponse do
  @moduledoc """
  Provides struct and type for a HeartbeatResponse
  """

  @type t :: %__MODULE__{nanosecond_heartbeat: integer}

  defstruct [:nanosecond_heartbeat]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [nanosecond_heartbeat: :integer]
  end
end
