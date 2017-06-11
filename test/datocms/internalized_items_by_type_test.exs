defmodule DatoCMS.InternalizedItemsByType.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    item_data = load_fixture("items1")
    {:ok, internalized_item_types_by_id} =
      DatoCMS.InternalizedItemTypesById.from(site)
    [
      items: item_data["data"],
      internalized_item_types_by_id: internalized_item_types_by_id
    ]
  end

  test "it groups items by type name and id", context do
    {:ok, collections} =
      DatoCMS.InternalizedItemsByType.from(
        context[:items], context[:internalized_item_types_by_id]
      )

    assert(Map.has_key?(collections, "post"))
    assert(Map.keys(collections["post"]) == ["12345"])
  end

  test "it internalizes items", context do
    {:ok, collections} = DatoCMS.InternalizedItemsByType.from(
      context[:items], context[:internalized_item_types_by_id]
    )

    post = collections["post"]["12345"]

    assert(post["title"] == "The Title")
    assert(post["category"] == {"category", "12346"})
    assert(post["tags"] == {"tag", ["12347"]})
  end
end
