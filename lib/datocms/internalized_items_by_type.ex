defmodule DatoCMS.InternalizedItemsByType do
  def from(items, internalized_item_types_by_id) do
    by_type(items, internalized_item_types_by_id, %{})
  end

  defp by_type([], _internalized_item_types_by_id, items_by_type) do
    {:ok, items_by_type}
  end
  defp by_type([item | rest], internalized_item_types_by_id, items_by_type) do
    type_id = get_in(item, [:relationships, :item_type, :data, :id])
    type_id_key = AtomKey.to_atom(type_id)
    type_name = internalized_item_types_by_id[type_id_key][:type_name]
    internalized = internalize(item, internalized_item_types_by_id)
    type = String.to_atom(type_name)
    type_items = Map.get(items_by_type, type, %{})
    id_key = AtomKey.to_atom(internalized[:id])
    updated_type_items = Map.put(type_items, id_key, internalized)
    updated = Map.put(items_by_type, type, updated_type_items)
    by_type(rest, internalized_item_types_by_id, updated)
  end

  defp internalize(item, internalized_item_types_by_id) do
    type_id = get_in(item, [:relationships, :item_type, :data, :id])
    type_id_key = AtomKey.to_atom(type_id)
    item_type = internalized_item_types_by_id[type_id_key]
    %{fields: fields} = item_type
    values = Enum.reduce(fields, %{}, fn (field, acc) ->
      %{field_name: field_name} = field
      name = String.to_atom(field_name)
      %{attributes: %{^name => raw_value}} = item
      value = field_value(field, raw_value, internalized_item_types_by_id)
      put_in(acc, [name], value)
    end)
    item_type_atom = AtomKey.to_atom(item_type.type_name)
    seo = item[:seo] || %{}
    %{id: id, attributes: %{updated_at: updated_at}} = item
    Map.merge(%{id: id, item_type: item_type_atom, seo: seo, updated_at: updated_at}, values)
  end

  defp field_value(
    %{
      attributes: %{
        field_type: "link",
        validators: %{
          item_item_type: %{item_types: [item_type_id]}
        }
      }
    },
    value,
    internalized_item_types_by_id
  ) do
    type_id_key = AtomKey.to_atom(item_type_id)
    item_type = internalized_item_types_by_id[type_id_key]
    %{type_name: linked_type} = item_type
    linked_type_key = AtomKey.to_atom(linked_type)
    {linked_type_key, value}
  end
  defp field_value(
    %{
      attributes: %{
        field_type: "links",
        validators: %{
          items_item_type: %{item_types: [item_type_id]}
        }
      }
    },
    value,
    internalized_item_types_by_id
  ) do
    type_id_key = AtomKey.to_atom(item_type_id)
    item_type = internalized_item_types_by_id[type_id_key]
    %{type_name: linked_type} = item_type
    linked_type_key = AtomKey.to_atom(linked_type)
    {linked_type_key, value}
  end
  defp field_value(_field, value, _internalized_item_types_by_id) do
    value
  end
end
