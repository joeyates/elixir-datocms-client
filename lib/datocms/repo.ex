defmodule DatoCMS.Repo do
  def load do
    {:ok, site} = DatoCMS.Site.fetch()
    {:ok, items} = DatoCMS.Items.fetch()
    {:ok, internalized_item_types_by_id} =
      DatoCMS.InternalizedItemTypesById.from(site)
    {:ok, items_by_type} =
      DatoCMS.InternalizedItemsByType.from(items, internalized_item_types_by_id)
    {
      :ok,
      [
        items_by_type: items_by_type,
        internalized_item_types_by_id: internalized_item_types_by_id,
        site: site
      ]
    }
  end
end
