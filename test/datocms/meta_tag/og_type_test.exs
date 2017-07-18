defmodule DatoCMS.MetaTag.OgType.Test do
  use ExUnit.Case, async: true

  setup context do
    item_type = %{attributes: %{singleton: context[:singleton]}}

    {:ok, tags} = DatoCMS.MetaTag.OgType.build(%{item_type: item_type})

    Map.merge(context, %{tags: tags})
  end

  describe "with a singleton item" do
    @tag singleton: true
    test "it returns a website tag", %{tags: tags} do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:type", content: "website"}},
        ]
      )
    end
  end

  describe "with a non-singleton item" do
    test "it returns an article tag", %{tags: tags} do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:type", content: "article"}},
        ]
      )
    end
  end
end
