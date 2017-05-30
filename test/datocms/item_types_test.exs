defmodule DatoCMS.ItemTypes.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    [site: site]
  end

  test "it extracts item types from the site", context do
    {:ok, items} = DatoCMS.ItemTypes.from(context[:site])

    assert(length(items) == 1)

    first = hd(items)

    assert(%{"id" => "123", "type" => "item_type"} = first)
  end
end
