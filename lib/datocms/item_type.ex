defmodule DatoCMS.ItemType do
  def from(item_type, fields_by_id) do
    %{id: id, attributes: %{api_key: type_name}} = item_type
    fields = build_fields(item_type, fields_by_id)
    {:ok, %{id: id, type_name: type_name, fields: fields}}
  end

  defp build_fields(item_type, fields_by_id) do
    fields_ids = extract_fields_ids(item_type)
    Enum.map(fields_ids, &(fields_by_id[&1]))
  end

  defp extract_fields_ids(item_type) do
    %{relationships: %{fields: %{data: fields}}} = item_type
    Enum.map(fields, &(AtomKey.to_atom(&1[:id])))
  end
end
