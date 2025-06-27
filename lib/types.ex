defmodule ExChromaDb.Types do
  @type embedding_vector() :: list(float())

  @type one_result(t) :: {:ok, t} | {:error, any()}
  @type list_result(t) :: {:ok, list(t)} | {:error, any()}
end
