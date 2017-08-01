defmodule IndexEntities do
  def by_id(entities) do
    Enum.reduce(entities, %{}, fn (i, acc) ->
      %{id: id} = i
      id_key = AtomKey.to_atom(id)
      put_in(acc, [id_key], i)
    end)
  end

  def by_key(entities, key) do
    Enum.reduce(entities, %{}, fn (item, acc) ->
      key_value = item[key]
      key_atom = AtomKey.to_atom(key_value)
      put_in(acc, [key_atom], item)
    end)
  end
end
