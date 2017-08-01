defmodule DatoCMS.ItemTypesByType.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper
  import AtomMap

  setup _context do
    site = load_fixture("site")
    site = atom_map(site)
    [site: site]
  end

  test "it groups item types by type name", context do
    {:ok, collections} =
      DatoCMS.ItemTypesByType.from(context[:site])

    assert(Map.keys(collections) == [:category, :post, :tag])
    assert(Map.keys(collections.post) == [:fields, :id, :type_name])
  end
end
