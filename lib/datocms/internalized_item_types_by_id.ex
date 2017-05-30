defmodule DatoCMS.InternalizedItemTypesById do
  def from(site) do
    {:ok, item_types} = DatoCMS.ItemTypes.from(site)
    {:ok, internalized_fields_by_id} = DatoCMS.InternalizedFieldsById.from(site)
    internalized_item_types = Enum.map(item_types, fn (i) ->
      {:ok, v} = DatoCMS.InternalizedItemType.from(i, internalized_fields_by_id)
      v
    end)
    {:ok, by_id(internalized_item_types)}
  end

  defp by_id(enumerable) do
    Enum.reduce(enumerable, %{}, fn (i, acc) ->
      %{"id" => id} = i
      put_in(acc, [id], i)
    end)
  end
end
