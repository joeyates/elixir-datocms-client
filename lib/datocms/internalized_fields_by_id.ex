defmodule DatoCMS.InternalizedFieldsById do
  def from(site) do
    {:ok, fields} = DatoCMS.Fields.from(site)
    internalized_fields = Enum.map(fields, fn (f) ->
      {:ok, v} = DatoCMS.InternalizedField.from(f)
      v
    end)
    {:ok, by_id(internalized_fields)}
  end

  defp by_id(enumerable) do
    Enum.reduce(enumerable, %{}, fn (i, acc) ->
      %{"id" => id} = i
      put_in(acc, [id], i)
    end)
  end
end
