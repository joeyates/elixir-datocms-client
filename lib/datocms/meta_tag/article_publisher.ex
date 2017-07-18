defmodule DatoCMS.MetaTag.ArticlePublisher do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site}) do
    facebook_page_url(site) |> handle_facebook_page_url
  end

  defp handle_facebook_page_url(nil) do
    {:ok, []}
  end
  defp handle_facebook_page_url(facebook_page_url) do
    {:ok, [og_tag("article:publisher", facebook_page_url)]}
  end

  defp facebook_page_url(%{attributes: %{global_seo: %{facebook_page_url: facebook_page_url}}}) do
    facebook_page_url
  end
  defp facebook_page_url(_site), do: nil
end
