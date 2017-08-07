defmodule DatoCMS.Transformer do
  import AtomMap

  def internalize(site, items) do
    site = atom_map(site)
    items = atom_map(items)
    {:ok, item_types_by_type} =
      DatoCMS.ItemTypesByType.from(site)
    {:ok, items_by_type} =
      DatoCMS.ItemsByType.from(items, item_types_by_type)
    {:ok, items_by_type} =
      DatoCMS.AddMissingSlugs.to(items_by_type, item_types_by_type)

    {
      :ok,
      [
        items_by_type: items_by_type,
        item_types_by_type: item_types_by_type,
        site: site
      ]
    }
  end
end
