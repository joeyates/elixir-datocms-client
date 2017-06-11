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
    type_items = Map.get(items_by_type, type_name, %{})
    updated_type_items = Map.put(type_items, internalized["id"], internalized)
    updated = Map.put(items_by_type, type_name, updated_type_items)
    by_type(rest, internalized_item_types_by_id, updated)
  end

  defp internalize(item, internalized_item_types_by_id) do
    type_id = get_in(item, ["relationships", "item_type", "data", "id"])
    item_type = internalized_item_types_by_id[type_id]
    %{"fields" => fields} = item_type
    values = Enum.reduce(fields, %{}, fn (field, acc) ->
      %{"field_name" => field_name} = field
      %{"attributes" => %{^field_name => raw_value}} = item
      value = field_value(field, raw_value, internalized_item_types_by_id)
      put_in(acc, [field_name], value)
    end)
    %{"id" => id, "attributes" => %{"seo" => seo, "updated_at" => updated_at}} = item
    Map.merge(%{"id" => id, "seo" => seo, "updated_at" => updated_at}, values)
  end

  defp field_value(
    %{
      "attributes" => %{
        "field_type" => "link",
        "validators" => %{
          "item_item_type" => %{"item_types" => [item_type_id]}
        }
      }
    } = field,
    value,
    internalized_item_types_by_id
  ) do
    item_type = internalized_item_types_by_id[item_type_id]
    %{"type_name" => linked_type} = item_type
    {linked_type, value}
  end
  defp field_value(
    %{
      "attributes" => %{
        "field_type" => "links",
        "validators" => %{
          "items_item_type" => %{"item_types" => [item_type_id]}
        }
      }
    } = field,
    value,
    internalized_item_types_by_id
  ) do
    item_type = internalized_item_types_by_id[item_type_id]
    %{"type_name" => linked_type} = item_type
    {linked_type, value}
  end
  defp field_value(_field, value, _internalized_item_types_by_id) do
    value
  end
end
