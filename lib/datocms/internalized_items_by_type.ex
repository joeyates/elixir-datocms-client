defmodule DatoCMS.InternalizedItemsByType do
  def from(items, internalized_item_types_by_id) do
    by_type(items, internalized_item_types_by_id, %{})
  end

  defp by_type([], _internalized_item_types_by_id, items_by_type) do
    {:ok, items_by_type}
  end

  defp by_type([item | rest], internalized_item_types_by_id, items_by_type) do
    type_id = get_in(item, ["relationships", "item_type", "data", "id"])
    type_name = internalized_item_types_by_id[type_id]["type_name"]
    internalized = internalize(item, internalized_item_types_by_id)
    type_items = Map.get(items_by_type, type_name, [])
    updated = put_in(items_by_type, [type_name], type_items ++ [internalized])
    by_type(rest, internalized_item_types_by_id, updated)
  end

  defp internalize(item, internalized_item_types_by_id) do
    type_id = get_in(item, ["relationships", "item_type", "data", "id"])
    item_type = internalized_item_types_by_id[type_id]
    %{"fields" => fields} = item_type
    values = Enum.reduce(fields, %{}, fn (field, acc) ->
      %{"field_name" => field_name} = field
      %{"attributes" => %{^field_name => value}} = item
      put_in(acc, [field_name], value)
    end)
    %{"id" => id, "attributes" => %{"seo" => seo, "updated_at" => updated_at}} = item
    Map.merge(%{"id" => id, "seo" => seo, "updated_at" => updated_at}, values)
  end
end
