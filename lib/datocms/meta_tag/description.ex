defmodule DatoCMS.MetaTag.Description do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site, item: item}) do
    item_seo_description = item_seo_description(item)
    fallback_seo_description = fallback_seo_description(site)
    handle_item_seo_description(item_seo_description, fallback_seo_description)
  end

  defp handle_item_seo_description(nil, nil) do
    {:ok, []}
  end
  defp handle_item_seo_description(nil, fallback_seo_description) do
    {
      :ok, [
        meta_tag("description", fallback_seo_description),
        og_tag("og:description", fallback_seo_description),
        card_tag("twitter:description", fallback_seo_description)
      ]
    }
  end
  defp handle_item_seo_description(item_seo_description, _fallback_seo_description) do
    {
      :ok, [
        meta_tag("description", item_seo_description),
        og_tag("og:description", item_seo_description),
        card_tag("twitter:description", item_seo_description)
      ]
    }
  end

  defp fallback_seo_description(
    %{attributes: %{global_seo: %{fallback_seo: %{description: description}}}}
  ), do: description
  defp fallback_seo_description(_item), do: nil

  defp item_seo_description(%{seo: %{description: description}}), do: description
  defp item_seo_description(_item), do: nil
end
