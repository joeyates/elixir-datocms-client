defmodule DatoCMS.MetaTag.Robots.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{attributes: %{no_index: context[:no_index]}}

    {:ok, tags} = DatoCMS.MetaTag.Robots.build(%{site: site})

    Map.merge(context, %{tags: tags})
  end

  describe "with no_index unset" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with no_index set" do
    @tag no_index: true
    test "it returns a noindex tag", %{tags: tags} do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{name: "robots", content: "noindex"}}
        ]
      )
    end
  end
end
