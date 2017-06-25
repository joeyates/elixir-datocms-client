defmodule IndexEntities do
  def by_id(entities) do
    Enum.reduce(entities, %{}, fn (i, acc) ->
      %{id: id} = i
      id_key = AtomKey.to_atom(id)
      put_in(acc, [id_key], i)
    end)
  end
end
