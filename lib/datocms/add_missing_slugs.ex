defmodule DatoCMS.AddMissingSlugs do
  alias FermoHelpers.Slug

  def to(items_by_type, item_types_by_type) do
    with_slugs = Enum.reduce(item_types_by_type, items_by_type, fn ({type_name, item_type}, acc) ->
      items = items_by_type[type_name]
      has_slugs = has_slugs?(item_type)
      with_slugs = if has_slugs do
        items
      else
        add_slugs(items, item_type)
      end
      Map.put(acc, item_type.type_name, with_slugs)
    end)

    {:ok, with_slugs}
  end

  defp has_slugs?(item_type) do
    Enum.any?(item_type.fields, fn f -> f.attributes.field_type == "slug" end)
  end

  defp add_slugs(nil, _item_type), do: nil
  defp add_slugs(items, item_type) do
    title_field(item_type) |> handle_title_field(items)
  end

  defp handle_title_field(nil, items), do: items
  defp handle_title_field(title_field, items) do
    localized = title_field.attributes.localized
    key = AtomKey.to_atom(title_field.attributes.api_key)
    Enum.reduce(items, %{}, fn ({id, item}, slugged_items) ->
      title = item[key]
      slug = if localized do
        Enum.reduce(title, %{}, fn ({locale, text}, acc) ->
          slug = Slug.from(id, text)
          Map.put(acc, locale, slug)
        end)
      else
        Slug.from(id, title)
      end
      slugged_item = Map.put(item, :slug, slug)
      Map.put(slugged_items, id, slugged_item)
    end)
  end

  defp title_field(%{fields: fields} = _item_type) do
    Enum.find(fields, fn (field) ->
      get_in(field, [:attributes, :appeareance, :type]) == "title"
    end)
  end
end
