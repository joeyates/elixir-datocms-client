defmodule DatoCMS.ItemsByType.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper
  import AtomMap

  setup _context do
    site = load_fixture("site")
    site = atom_map(site)
    item_data = load_fixture("items1")
    item_data = atom_map(item_data)
    {:ok, item_types_by_id} =
      DatoCMS.ItemTypesById.from(site)

    [
      items: item_data[:data],
      item_types_by_id: item_types_by_id
    ]
  end

  test "it groups items by type name and id", context do
    {:ok, collections} =
      DatoCMS.ItemsByType.from(
        context[:items], context[:item_types_by_id]
      )

    assert(Map.has_key?(collections, :post))
    assert(Map.keys(collections.post) == [:"12345"])
  end

  test "it internalizes items", context do
    {:ok, collections} = DatoCMS.ItemsByType.from(
      context.items, context.item_types_by_id
    )

    post = collections.post[:"12345"]

    assert(post.item_type == :post)
    assert(post.title == %{en: "The Title", it: "Il titolo"})
    assert(post.category == {:category, "12346"})
    assert(post.tags == {:tag, ["12347"]})
  end
end
