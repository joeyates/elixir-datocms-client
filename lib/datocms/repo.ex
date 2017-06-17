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

  def all(repo, type) do
    {:ok, repo[:items_by_type][type]}
  end

  def all!(repo, type) do
    {:ok, all} = all(repo, type)
    all
  end

  def get(repo, {type, ids}) when is_list(ids) do
    {:ok, locale} = default_locale(repo)
    get(repo, {type, ids, locale})
  end
  def get(repo, {type, ids, locale}) when is_list(ids) do
    items = repo[:items_by_type][type]
    requested = Enum.map(ids, fn (id) ->
      localize(items[id], locale)
    end)
    {:ok, requested}
  end
  def get(repo, {type, id}) do
    {:ok, locale} = default_locale(repo)
    get(repo, {type, id, locale})
  end
  def get(repo, {type, id, locale}) do
    items = repo[:items_by_type][type]
    item = localize(items[id], locale)
    {:ok, item}
  end

  defp localize(item, locale) do
    Enum.reduce(item, %{}, fn ({k, v}, acc) ->
      value = localize_field(k, v, locale)
      Map.put(acc, k, value)
    end)
  end

  defp localize_field("seo", v, locale) do
    localize(v, locale)
  end
  defp localize_field(_k, %{} = v, locale) do
    v[locale]
  end
  defp localize_field(_k, v, _locale) do
    v
  end

  def get!(repo, {type, id}) do
    {:ok, item} = get(repo, {type, id})
    item
  end

  def default_locale(repo) do
    %{
      "data" => %{
        "attributes" => %{
          "locales" => [first_locale | _]
        }
      }
    } = repo[:site]
    {:ok, first_locale}
  end
end
