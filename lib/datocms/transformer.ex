defmodule DatoCMS.Transformer do
  def internalize(site, items) do
    site = atomize(site)
    items = atomize(items)
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

  defp atomize(data) when is_list(data) do
    Enum.map(data, &atomize/1)
  end
  defp atomize(data) when is_map(data) do
    elem(Morphix.atomorphiform(data), 1)
  end
  defp atomize(data), do: data
end
