defmodule DatoCMS.InternalizedItemTypeTest do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    %{"included" => [item_type | [field]]} = site
    fields_by_id = %{field["id"] => field}
    [
      item_type: item_type,
      field: field,
      fields_by_id: fields_by_id
    ]
  end

  test "it sets the type_name", context do
    {:ok, result} = DatoCMS.InternalizedItemType.from(
      context[:item_type], context[:fields_by_id]
    )
    assert(result["type_name"] == "post")
  end

  test "it maintains the id", context do
    {:ok, result} = DatoCMS.InternalizedItemType.from(
      context[:item_type], context[:fields_by_id]
    )
    assert(result["id"] == "123")
  end

  test "it adds fields as an array", context do
    {:ok, result} = DatoCMS.InternalizedItemType.from(
      context[:item_type], context[:fields_by_id]
    )
    assert(length(result["fields"]) == 1)
    first = hd(result["fields"])
    assert(first == context[:field])
  end
end
