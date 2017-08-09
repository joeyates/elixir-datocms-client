defmodule DatoCMS.TransformField.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")

    included = site.included
    field = Enum.fetch!(included, 1)

    [field: field]
  end

  test "it maintains the id", context do
    {:ok, result} = DatoCMS.TransformField.from(context[:field])
    assert(result.id == "1234")
  end

  test "it sets the field_name", context do
    {:ok, result} = DatoCMS.TransformField.from(context[:field])
    assert(result.field_name == "title")
  end
end
