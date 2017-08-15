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

  def site do
    GenServer.call(:repo, {:site})
  end

  def site! do
    {:ok, site} = site()
    site
  end

  def localized_items_of_type(type, locale) do
    GenServer.call(:repo, {:localized_items_of_type, type, locale})
  end

  def localized_items_of_type!(type, locale) do
    {:ok, localized_items_of_type} = localized_items_of_type(type, locale)
    localized_items_of_type
  end

  def get(specifier) do
    GenServer.call(:repo, {:get, {specifier}})
  end
  def get(specifier, locale) do
    GenServer.call(:repo, {:get, {specifier, locale}})
  end

  def get!(specifier) do
    {:ok, result} = get(specifier)
    result
  end
  def get!(specifier, locale) do
    {:ok, result} = get(specifier, locale)
    result
  end

  def item_type(type) do
    GenServer.call(:repo, {:item_type, type})
  end

  def item_type!(type) do
    {:ok, result} = item_type(type)
    result
  end

  def handle_call({:put, state}, _from, _state) do
    {:reply, {:ok}, state}
  end
  def handle_call({:all}, _from, state) do
    {:reply, {:ok, state}, state}
  end
  def handle_call({:site}, _from, state) do
    site = state[:site]
    {:reply, {:ok, site}, state}
  end
  def handle_call({:localized_items_of_type, type, locale}, _from, state) do
    unlocalized = handle_items_of_type(type, state)
    item_type = item_type(type, state)
    items = Enum.map(unlocalized, fn ({_id, item}) ->
      localize(item, item_type, locale)
    end)
    {:reply, {:ok, items}, state}
  end
  def handle_call({:get, {specifier}}, _from, state) do
    handle_get(specifier, state)
  end
  def handle_call({:get, {specifier, locale}}, _from, state) do
    handle_get(specifier, locale, state)
  end
  def handle_call({:item_type, type}, _from, state) do
    item_type(type, state) |> handle_item_type(state)
  end

  def handle_items_of_type(type, state) when is_atom(type) do
    state[:items_by_type][type]
  end
  def handle_items_of_type(type, state) do
    type_key = AtomKey.to_atom(type)
    handle_items_of_type(type_key, state)
  end

  def handle_get({type, ids}, locale, state) when is_list(ids) do
    items = handle_items_of_type(type, state)
    item_type = item_type(type, state)
    localized_items = Enum.map(ids, fn (id) ->
      item_key = AtomKey.to_atom(id)
      localize(items[item_key], item_type, locale)
    end)
    {:reply, {:ok, localized_items}, state}
  end
  def handle_get({type, nil}, _locale, state) do
    {:reply, {:ok, nil}, state}
  end
  def handle_get({type, id}, locale, state) do
    items = handle_items_of_type(type, state)
    item_key = AtomKey.to_atom(id)
    item_type = item_type(type, state)
    item = localize(items[item_key], item_type, locale)
    {:reply, {:ok, item}, state}
  end
  def handle_get({type}, locale, state) do
    items = handle_items_of_type(type, state)
    first = hd(Map.keys(items))
    item_key = AtomKey.to_atom(first)
    item_type = item_type(type, state)
    item = localize(items[item_key], item_type, locale)
    {:reply, {:ok, item}, state}
  end
  def handle_get({type, ids}, state) when is_list(ids) do
    {:ok, locale} = default_locale(state)
    handle_get({type, ids}, locale, state)
  end
  def handle_get({type, id}, state) do
    {:ok, locale} = default_locale(state)
    handle_get({type, id}, locale, state)
  end
  def handle_get({type}, state) do
    {:ok, locale} = default_locale(state)
    handle_get({type}, locale, state)
  end

  def handle_item_type(item_type, state) do
    {:reply, {:ok, item_type}, state}
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

  def localize(item, item_type, locale) do
    field_types = Enum.reduce(item_type.fields, %{slug: "string"}, fn (f, acc) ->
      %{attributes: %{api_key: api_key, field_type: field_type}} = f
      Map.put(acc, String.to_atom(api_key), field_type)
    end)
    Enum.reduce(item, %{}, fn ({k, v}, acc) ->
      type = field_types[k]
      value = if type == "string" || type == "text" do
        localize_field(k, v, locale)
      else
        v
      end
      Map.put(acc, k, value)
    end)
  end

  defp localize_field(_k, %{} = v, locale) do
    v[locale]
  end
  defp localize_field(_k, v, _locale) do
    v
  end

  defp item_type(type, state) do
    item_types = state[:item_types_by_type]
    type_name = AtomKey.to_atom(type)
    item_types[type_name]
  end
end
