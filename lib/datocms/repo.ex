defmodule DatoCMS.Repo do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :repo)
  end

  def put(state) do
    GenServer.call(:repo, {:put, state})
  end

  def all(type) do
    GenServer.call(:repo, {:all, type})
  end

  def all!(type) do
    {:ok, all} = all(type)
    all
  end

  def get(specifier) do
    GenServer.call(:repo, {:get, specifier})
  end

  def get!(specifier) do
    {:ok, result} = get(specifier)
    result
  end

  def handle_call({:put, state}, _from, _state) do
    {:reply, {:ok}, state}
  end
  def handle_call({:all, type}, _from, state) do
    items = state[:items_by_type][type]
    {:reply, {:ok, items}, state}
  end
  def handle_call({:get, specifier}, _from, state) do
    handle_get(specifier, state)
  end

  def handle_get({type, ids}, state) when is_list(ids) do
    {:ok, locale} = default_locale(state)
    handle_get(state, {type, ids, locale})
  end
  def handle_get({type, ids, locale}, state) when is_list(ids) do
    items = state[:items_by_type][type]
    requested = Enum.map(ids, fn (id) ->
      localize(items[id], locale)
    end)
    {:ok, requested}
  end
  def handle_get({type, id}, state) do
    {:ok, locale} = default_locale(state)
    handle_get(state, {type, id, locale})
  end
  def handle_get({type, id, locale}, state) do
    items = state[:items_by_type][type]
    item = localize(items[id], locale)
    {:ok, item}
  end

  defp default_locale(state) do
    %{
      "data" => %{
        "attributes" => %{
          "locales" => [first_locale | _]
        }
      }
    } = state[:site]
    {:ok, first_locale}
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
end
