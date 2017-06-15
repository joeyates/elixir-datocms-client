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

  def all!(repo, type) do
    {:ok, all} = all(repo, type)
    all
  end
  def all(repo, type) do
    {:ok, repo[:items_by_type][type]}
  end

  def get!(repo, {type, id}) do
    {:ok, item} = get(repo, {type, id})
    item
  end

  def get(repo, {type, ids}) when is_list(ids) do
    all = repo[:items_by_type][type]
    {:ok, Enum.map(ids, fn (id) -> all[id] end)}
  end
  def get(repo, {type, id}) do
    all = repo[:items_by_type][type]
    {:ok, all[id]}
  end
end
