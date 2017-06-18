defmodule DatoCMS.Internalizer.Test do
  use ExUnit.Case, async: true
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    site = load_fixture("site")
    %{"data" => items} = load_fixture("items1")

    [site: site, items: items]
  end

  describe ".load" do
    test "returns all site data", context do
      {:ok, repo} = DatoCMS.Internalizer.internalize(
        context[:site], context[:items]
      )

      assert(
        Keyword.keys(repo) == [
          :items_by_type, :internalized_item_types_by_id, :site
        ]
      )
    end
  end
end
