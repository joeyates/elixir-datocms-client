defmodule DatoCMS.MetaTag.OgSiteName do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site}) do
    site_name(site) |> handle_site_name
  end

  defp handle_site_name(nil) do
    {:ok, []}
  end
  defp handle_site_name(site_name) do
    {:ok, [og_tag("og:site_name", site_name)]}
  end

  defp site_name(%{attributes: %{global_seo: %{site_name: site_name}}}) do
    site_name
  end
  defp site_name(_site), do: nil
end
