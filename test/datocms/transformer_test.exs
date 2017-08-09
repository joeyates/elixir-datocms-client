defmodule DatoCMS.Transformer.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    %{data: items} = load_fixture("items1")

    [site: site, items: items]
  end

  describe ".load" do
    test "returns all site data", context do
      {:ok, state} = DatoCMS.Transformer.internalize(
        context[:site], context[:items]
      )

      assert(
        Keyword.keys(state) == [:items_by_type, :item_types_by_type, :site]
      )
    end
  end
end
