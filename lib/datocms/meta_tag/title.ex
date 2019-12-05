defmodule DatoCMS.MetaTag.Title do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site, item_type: item_type, item: item}) do
    item_seo_title = item_seo_title(item)
    item_title = item_title(item, item_type)
    fallback_seo_title = fallback_seo_title(site)
    handle_item_seo_title(item_seo_title, item_title, fallback_seo_title, site)
  end

  defp handle_item_seo_title(nil, nil, nil, _site) do
    {:ok, []}
  end
  defp handle_item_seo_title(nil, nil, fallback_seo_title, _site) do
    {
      :ok, [
        content_tag("title", fallback_seo_title),
        og_tag("og:title", fallback_seo_title),
        card_tag("twitter:title", fallback_seo_title)
      ]
    }
  end
  defp handle_item_seo_title(nil, item_title, _fallback_seo_title, site) do
    item_title_with_suffix = add_suffix(item_title, site)
    {
      :ok, [
        content_tag("title", item_title_with_suffix),
        og_tag("og:title", item_title),
        card_tag("twitter:title", item_title)
      ]
    }
  end
  defp handle_item_seo_title(item_seo_title, _item_title, _fallback_seo_title, _site) do
    {
      :ok, [
        content_tag("title", item_seo_title),
        og_tag("og:title", item_seo_title),
        card_tag("twitter:title", item_seo_title)
      ]
    }
  end

  defp fallback_seo_title(
    %{attributes: %{global_seo: %{fallback_seo: %{title: title}}}}
  ), do: title
  defp fallback_seo_title(_item), do: nil

  defp item_seo_title(%{seo: %{title: title}}), do: title
  defp item_seo_title(_item), do: nil

  defp item_title(item, item_type) do
    title_field = title_field(item_type)
    item[title_field]
  end

  defp title_field(item_type) do
    Enum.find(item_type.fields, fn (%{attributes: attributes}) ->
      type = Map.get(attributes.appeareance, :type)
      attributes.field_type == "string" && type == "title"
    end) |> name_from_field
  end

  defp name_from_field(nil), do: nil
  defp name_from_field(field), do: String.to_atom(field.attributes.api_key)

  defp add_suffix(
    item_title,
    %{attributes: %{global_seo: %{title_suffix: title_suffix}}}
  ) do
    joined = "#{item_title}#{title_suffix}"
    if String.length(joined) <= 60 do
      joined
    else
      item_title
    end
  end
  defp add_suffix(item_title, _site), do: item_title
end
