defmodule DatoCMS.ItemTypesByType do
  def from(site) do
    {:ok, item_types} = DatoCMS.ItemTypes.from(site)
    {:ok, fields_by_id} = DatoCMS.FieldsById.from(site)
    item_types = Enum.map(item_types, fn (i) ->
      {:ok, v} = DatoCMS.ItemType.from(i, fields_by_id)
      v
    end)
    {:ok, IndexEntities.by_key(item_types, :type_name)}
  end
end
