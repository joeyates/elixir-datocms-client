defmodule DatoCMS.InternalizedField.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    %{"included" => [_item_type | [field]]} = site
    [
      field: field,
    ]
  end

  test "it maintains the id", context do
    {:ok, result} = DatoCMS.InternalizedField.from(context[:field])
    assert(result["id"] == "1234")
  end

  test "it sets the field_name", context do
    {:ok, result} = DatoCMS.InternalizedField.from(context[:field])
    assert(result["field_name"] == "title")
  end
end
