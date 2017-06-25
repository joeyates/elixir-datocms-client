defmodule DatoCMS.ItemTypes do
  def from(site) do
    site.included |> item_types([])
  end

  defp item_types([], items) do
    {:ok, items}
  end
  defp item_types([item_type = %{type: "item_type"} | rest], items) do
    item_types(rest, items ++ [item_type])
  end
  defp item_types([_other | rest], items) do
    item_types(rest, items)
  end
end
