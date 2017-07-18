defmodule DatoCMS.MetaTag.ArticleModifiedTime do
  import DatoCMS.MetaTag.Helpers

  def build(%{item: item}) do
    updated_at(item) |> handle_updated_at
  end

  defp handle_updated_at(nil) do
    {:ok, []}
  end
  defp handle_updated_at(updated_at) do
    {:ok, [og_tag("article:modified_time", updated_at)]}
  end

  defp updated_at(%{attributes: %{updated_at: updated_at}}) do
    updated_at
  end
  defp updated_at(_item), do: nil
end
