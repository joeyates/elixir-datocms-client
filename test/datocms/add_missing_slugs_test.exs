defmodule DatoCMS.AddMissingSlugs.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper
  import AtomMap

  setup do
    site = load_fixture("site")
    site = atom_map(site)
    item_data = load_fixture("items1")
    item_data = atom_map(item_data)
    items = item_data[:data]

    {:ok, item_types_by_type} =
      DatoCMS.ItemTypesByType.from(site)
    {:ok, original_items_by_type} =
      DatoCMS.ItemsByType.from(items, item_types_by_type)

    {:ok, items_by_type} = DatoCMS.AddMissingSlugs.to(
      original_items_by_type, item_types_by_type
    )

    [
      items_by_type: items_by_type,
      original_items_by_type: original_items_by_type
    ]
  end

  test "it adds slugs based on the title field", context do
    posts = context[:items_by_type].post
    item = posts[:"12345"]

    assert(item.slug == %{en: "12345-the-title", it: "12345-il-titolo"})
  end
end