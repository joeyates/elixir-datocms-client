defmodule DatoCMS.ItemsByType do
  def from(items, item_types_by_type) do
    type_id_to_type_name = build_type_map(item_types_by_type)
    by_type(items, item_types_by_type, type_id_to_type_name, %{})
  end

  defp build_type_map(item_types_by_type) do
    Enum.reduce(item_types_by_type, %{}, fn ({type, item_type}, acc) ->
      id_atom = AtomKey.to_atom(item_type.id)
      put_in(acc, [id_atom], type)
    end)
  end

  defp by_type([], _item_types_by_type, _type_id_to_type_name, items_by_type) do
    {:ok, items_by_type}
  end
  defp by_type([item | rest], item_types_by_type, type_id_to_type_name, items_by_type) do
    type_id = get_in(item, [:relationships, :item_type, :data, :id])
    type_name = type_name(type_id, type_id_to_type_name)
    internalized = internalize(item, item_types_by_type, type_id_to_type_name)
    type_items = Map.get(items_by_type, type_name, %{})
    item_id = AtomKey.to_atom(internalized[:id])
    updated_type_items = Map.put(type_items, item_id, internalized)
    updated = Map.put(items_by_type, type_name, updated_type_items)
    by_type(rest, item_types_by_type, type_id_to_type_name, updated)
  end

  defp internalize(item, item_types_by_type, type_id_to_type_name) do
    type_id = get_in(item, [:relationships, :item_type, :data, :id])
    type_name = type_name(type_id, type_id_to_type_name)
    item_type = item_types_by_type[type_name]
    %{fields: fields} = item_type
    values = Enum.reduce(fields, %{}, fn (field, acc) ->
      %{field_name: field_name} = field
      name = String.to_atom(field_name)
      %{attributes: %{^name => raw_value}} = item
      value = field_value(field, raw_value, item_types_by_type, type_id_to_type_name)
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
    item_types_by_type,
    type_id_to_type_name
  ) do
    type_name = type_name(item_type_id, type_id_to_type_name)
    item_type = item_types_by_type[type_name]
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
    item_types_by_type,
    type_id_to_type_name
  ) do
    type_name = type_name(item_type_id, type_id_to_type_name)
    item_type = item_types_by_type[type_name]
    %{type_name: linked_type} = item_type
    linked_type_key = AtomKey.to_atom(linked_type)
    {linked_type_key, value}
  end
  defp field_value(_field, value, _item_types_by_type, _type_id_to_type_name) do
    value
  end

  defp type_name(type_id, type_id_to_type_name) do
    type_id_atom = AtomKey.to_atom(type_id)
    type_id_to_type_name[type_id_atom]
  end
end
