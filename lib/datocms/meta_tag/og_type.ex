defmodule DatoCMS.MetaTag.OgType do
  import DatoCMS.MetaTag.Helpers

  def build(%{item_type: item_type}) do
    handle_item_type(item_type)
  end

  defp handle_item_type(%{attributes: %{singleton: true}}) do
    {:ok, [og_tag("og:type", "website")]}
  end
  defp handle_item_type(_item_type) do
    {:ok, [og_tag("og:type", "article")]}
  end
end
