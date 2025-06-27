defmodule ExChromaDb.Map do
  def atom_keys_to_binary(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {Atom.to_string(k), v} end)
  end

  def binary_keys_to_existing_atom(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end

  def binary_keys_to_atom(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  def maybe_put(map, _key, nil), do: map

  def maybe_put(map, key, value), do: Map.put(map, key, value)

  @spec merge_all(list(map())) :: map()
  def merge_all(maps) do
    Enum.reduce(maps, Map.new(), fn x, acc -> Map.merge(acc, x) end)
  end

  def convert(data) when is_struct(data) do
    data |> Map.from_struct() |> convert
  end

  def convert(data) when is_map(data) do
    Map.new(data, fn {k, v} -> {k, convert(v)} end)
  end

  def convert(data) when is_list(data) do
    Enum.map(data, &convert/1)
  end

  def convert(data), do: data

  def delete_key_if_default(map, key, value, default \\ nil) do
    case value do
      ^default -> Map.delete(map, key)
      _ -> map
    end
  end

  def get(map, key, default \\ nil)

  def get(map, key, default) when is_map(map) do
    Map.get(map, key, default)
  end

  def get(nil, _, _) do
    nil
  end
end
