defmodule DatoCMS.Repo do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :repo)
  end

  def put(state) do
    GenServer.call(:repo, {:put, state})
  end

  def all do
    GenServer.call(:repo, {:all})
  end

  def all! do
    {:ok, state} = all()
    state
  end

  def items_of_type(type) do
    GenServer.call(:repo, {:items_of_type, type})
  end

  def items_of_type!(type) do
    {:ok, items_of_type} = items_of_type(type)
    items_of_type
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
  def handle_call({:all}, _from, state) do
    {:reply, {:ok, state}, state}
  end
  def handle_call({:items_of_type, type}, _from, state) do
    items = handle_items_of_type(type, state)
    {:reply, {:ok, items}, state}
  end
  def handle_call({:get, specifier}, _from, state) do
    handle_get(specifier, state)
  end

  def handle_items_of_type(type, state) when is_atom(type) do
    state[:items_by_type][type]
  end
  def handle_items_of_type(type, state) do
    type_key = AtomKey.to_atom(type)
    handle_items_of_type(type_key, state)
  end

  def handle_get({type, ids}, state) when is_list(ids) do
    {:ok, locale} = default_locale(state)
    handle_get({type, ids, locale}, state)
  end
  def handle_get({type, ids, locale}, state) when is_list(ids) do
    items = handle_items_of_type(type, state)
    localized_items = Enum.map(ids, fn (id) ->
      item_key = AtomKey.to_atom(id)
      localize(items[item_key], locale)
    end)
    {:reply, {:ok, localized_items}, state}
  end
  def handle_get({type, locale}, state) when is_atom(locale) do
    items = handle_items_of_type(type, state)
    first = hd(Map.keys(items))
    item_key = AtomKey.to_atom(first)
    item = localize(items[item_key], locale)
    {:reply, {:ok, item}, state}
  end
  def handle_get({type}, state) do
    {:ok, locale} = default_locale(state)
    handle_get({type, locale}, state)
  end
  def handle_get({type, id}, state) do
    {:ok, locale} = default_locale(state)
    handle_get({type, id, locale}, state)
  end
  def handle_get({type, id, locale}, state) do
    items = handle_items_of_type(type, state)
    item_key = AtomKey.to_atom(id)
    item = localize(items[item_key], locale)
    {:reply, {:ok, item}, state}
  end

  defp default_locale(state) do
    %{
      data: %{
        attributes: %{
          locales: [first_locale | _]
        }
      }
    } = state[:site]
    {:ok, AtomKey.to_atom(first_locale)}
  end

  defp localize(item, locale) do
    Enum.reduce(item, %{}, fn ({k, v}, acc) ->
      value = localize_field(k, v, locale)
      Map.put(acc, k, value)
    end)
  end

  defp localize_field(:seo, v, locale) do
    localize(v, locale)
  end
  defp localize_field(_k, %{} = v, locale) do
    v[locale]
  end
  defp localize_field(_k, v, _locale) do
    v
  end
end
