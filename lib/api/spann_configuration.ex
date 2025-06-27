defmodule ExChromaDb.Api.SpannConfiguration do
  @moduledoc """
  Provides struct and type for a SpannConfiguration
  """

  @type t :: %__MODULE__{
          construction_ef: integer,
          m: integer,
          search_ef: integer,
          search_nprobe: integer,
          space: String.t(),
          write_nprobe: integer
        }

  defstruct [:construction_ef, :m, :search_ef, :search_nprobe, :space, :write_nprobe]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      construction_ef: :integer,
      m: :integer,
      search_ef: :integer,
      search_nprobe: :integer,
      space: {:enum, ["l2", "cosine", "ip"]},
      write_nprobe: :integer
    ]
  end
end
