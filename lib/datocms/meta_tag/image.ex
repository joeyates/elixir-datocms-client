defmodule DatoCMS.MetaTag.Image do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site, item_type: item_type, item: item}) do
    item_seo_image = item_seo_image(item)
    item_image = item_image(item, item_type)
    fallback_seo_image = fallback_seo_image(site)
    handle_item_seo_image(item_seo_image, item_image, fallback_seo_image, site)
  end

  defp handle_item_seo_image(nil, nil, nil, _site) do
    {:ok, []}
  end
  defp handle_item_seo_image(nil, nil, fallback_seo_image, site) do
    {
      :ok, [
        og_tag("og:image", image_url(fallback_seo_image, site)),
        card_tag("twitter:image", image_url(fallback_seo_image, site))
      ]
    }
  end
  defp handle_item_seo_image(nil, item_image, _fallback_seo_image, site) do
    {
      :ok, [
        og_tag("og:image", image_url(item_image, site)),
        card_tag("twitter:image", image_url(item_image, site))
      ]
    }
  end
  defp handle_item_seo_image(item_seo_image, _item_image, _fallback_seo_image, site) do
    {
      :ok, [
        og_tag("og:image", image_url(item_seo_image, site)),
        card_tag("twitter:image", image_url(item_seo_image, site))
      ]
    }
  end

  defp fallback_seo_image(
    %{data: %{attributes: %{global_seo: %{fallback_seo: %{image: image}}}}}
  ), do: image
  defp fallback_seo_image(_item), do: nil

  defp item_seo_image(%{seo: %{image: image}}), do: image
  defp item_seo_image(_item), do: nil

  defp item_image(item, item_type) do
    image_fields = image_fields(item_type)
    Enum.find_value(image_fields, fn (field) ->
      image = item[field]
      if image && image.height >= 200 && image.width >= 200 do
        image
      end
    end)
  end

  defp image_fields(item_type) do
    image_fields = Enum.filter(item_type.fields, fn (field) ->
      field.attributes.field_type == "image"
    end)
    Enum.map(image_fields, fn (field) -> String.to_atom(field.attributes.api_key) end)
  end

  defp image_url(image, site) do
    DatoCMS.Image.url_for(image, %{}, site)
  end
end
