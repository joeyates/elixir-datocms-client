defmodule DatoCMS.ItemType.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper
  import AtomMap

  setup _context do
    site = load_fixture("site")
    site = atom_map(site)

    item_type = hd(site.included)
    {:ok, fields_by_id} = DatoCMS.FieldsById.from(site)
    [
      item_type: item_type,
      fields_by_id: fields_by_id
    ]
  end

  test "it sets the type_name", context do
    {:ok, result} = DatoCMS.ItemType.from(
      context.item_type, context.fields_by_id
    )
    assert(result.type_name == :post)
  end

  test "it maintains the id", context do
    {:ok, result} = DatoCMS.ItemType.from(
      context.item_type, context.fields_by_id
    )
    assert(result.id == "123")
  end

  test "it adds fields as an array", context do
    {:ok, result} = DatoCMS.ItemType.from(
      context.item_type, context.fields_by_id
    )
    fields = result.fields
    assert(length(fields) == 4)
    assert(Enum.fetch!(fields, 0) == context.fields_by_id[:"1234"])
    assert(Enum.fetch!(fields, 1) == context.fields_by_id[:"1239"])
    assert(Enum.fetch!(fields, 2) == context.fields_by_id[:"1235"])
    assert(Enum.fetch!(fields, 3) == context.fields_by_id[:"1236"])
  end
end
