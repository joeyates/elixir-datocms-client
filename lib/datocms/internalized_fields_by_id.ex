defmodule DatoCMS.InternalizedFieldsById do
  def from(site) do
    {:ok, fields} = DatoCMS.Fields.from(site)
    internalized_fields = Enum.map(fields, fn (f) ->
      {:ok, v} = DatoCMS.InternalizedField.from(f)
      v
    end)
    {:ok, IndexEntities.by_id(internalized_fields)}
  end
end
