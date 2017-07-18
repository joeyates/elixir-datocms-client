defmodule DatoCMS.MetaTag.Robots do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site}) do
    site_no_index(site) |> handle_no_index
  end

  defp handle_no_index(nil) do
    {:ok, []}
  end
  defp handle_no_index(false) do
    {:ok, []}
  end
  defp handle_no_index(_no_index) do
    {:ok, [meta_tag("robots", "noindex")]}
  end

  defp site_no_index(%{attributes: %{no_index: no_index}}) do
    no_index
  end
  defp site_no_index(_item), do: nil
end
