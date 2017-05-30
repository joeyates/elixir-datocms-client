defmodule DatoCMS.Fields do
  def from(site) do
    by_id(site["included"], [])
  end

  defp by_id([], fields) do
    {:ok, fields}
  end
  defp by_id([field = %{"type" => "field"} | rest], fields) do
    by_id(rest, fields ++ [field])
  end
  defp by_id([_other | rest], fields) do
    by_id(rest, fields)
  end
end
