defmodule DatoCMS.Repo do
  def all(state, type) do
    {:ok, state[:items_by_type][type]}
  end

  def all!(state, type) do
    {:ok, all} = all(state, type)
    all
  end

  def get(state, {type, ids}) when is_list(ids) do
    {:ok, locale} = default_locale(state)
    get(state, {type, ids, locale})
  end
  def get(state, {type, ids, locale}) when is_list(ids) do
    items = state[:items_by_type][type]
    requested = Enum.map(ids, fn (id) ->
      localize(items[id], locale)
    end)
    {:ok, requested}
  end
  def get(state, {type, id}) do
    {:ok, locale} = default_locale(state)
    get(state, {type, id, locale})
  end
  def get(state, {type, id, locale}) do
    items = state[:items_by_type][type]
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

  def get!(state, {type, id}) do
    {:ok, item} = get(state, {type, id})
    item
  end

  def default_locale(state) do
    %{
      "data" => %{
        "attributes" => %{
          "locales" => [first_locale | _]
        }
      }
    } = state[:site]
    {:ok, first_locale}
  end
end
