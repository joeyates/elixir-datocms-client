defmodule DatoCMS.MetaTags.Test do
  use ExUnit.Case, async: false
  import DatoCMS.Test.Support.FixtureHelper

  setup _context do
    on_exit fn ->
      DatoCMS.put(nil)
    end

    site = load_fixture("site")
    %{data: items} = load_fixture("items1")

    {:ok, state} = DatoCMS.Transformer.internalize(site, items)
    DatoCMS.Repo.put(state)

    :ok
  end

  test "it returns meta tags" do
    {:ok, tags} = DatoCMS.MetaTags.for_item({:post, "12345"}, :en)

    assert(
      tags == [
        %{content: "Il titolo", tag_name: "title"},
        %{attributes: %{content: "Il titolo", property: "og:title"}, tag_name: "meta"},
        %{attributes: %{content: "Il titolo", name: "twitter:title"}, tag_name: "meta"},
        %{attributes: %{content: "en_EN", property: "og:locale"}, tag_name: "meta"},
        %{attributes: %{content: "article", property: "og:type"}, tag_name: "meta"},
        %{attributes: %{content: "summary", name: "twitter:card"}, tag_name: "meta"}
      ]
    )
  end
end
