defmodule DatoCMS.FieldsById do
  def from(site) do
    {:ok, fields} = DatoCMS.Fields.from(site)
    fields = Enum.map(fields, fn (f) ->
      {:ok, v} = DatoCMS.TransformField.from(f)
      v
    end)
    {:ok, IndexEntities.by_id(fields)}
  end
end
