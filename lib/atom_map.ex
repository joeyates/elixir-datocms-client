defmodule AtomMap do
  def atom_map(map) when is_map(map) do
    Map.new(map, fn ({k,v}) ->
      {AtomKey.to_atom(k), atom_map(v)}
    end)
  end
  def atom_map(list) when is_list(list) do
    Enum.map(list, fn (i) -> atom_map(i) end)
  end
  def atom_map(other), do: other
end
