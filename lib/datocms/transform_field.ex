defmodule DatoCMS.TransformField do
  def from(field) do
    %{attributes: %{api_key: field_name}} = field
    {:ok, put_in(field, [:field_name], field_name)}
  end
end
