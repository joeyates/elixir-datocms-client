defmodule IndexEntities do
  def by_id(entities) do
    Enum.reduce(entities, %{}, fn (i, acc) ->
      %{"id" => id} = i
      put_in(acc, [id], i)
    end)
  end
end
