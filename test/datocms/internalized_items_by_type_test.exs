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

  test "it groups items by type name", context do
    {:ok, collections} =
      DatoCMS.InternalizedItemsByType.from(
        context[:items], context[:internalized_item_types_by_id]
      )

    assert(Map.has_key?(collections, "post"))
    assert(length(collections["post"]) == 1)
  end

  test "it internalizes items", context do
    {:ok, collections} = DatoCMS.InternalizedItemsByType.from(
      context[:items], context[:internalized_item_types_by_id]
    )

    post = hd(collections["post"])

    assert(post["title"] == "The Title")
  end
end
