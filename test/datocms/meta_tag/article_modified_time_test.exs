defmodule DatoCMS.MetaTag.ArticleModifiedTime.Test do
  use ExUnit.Case, async: true

  setup context do
    item = %{attributes: %{updated_at: context[:updated_at]}}

    {:ok, tags} = DatoCMS.MetaTag.ArticleModifiedTime.build(%{item: item})

    Map.merge(context, %{tags: tags})
  end

  @tag updated_at: "2017-07-18T17:59:45Z"
  test "it returns the updated time in ISO 8601 format", %{
    tags: tags, updated_at: updated_at
  } do
    assert(
      tags == [
        %{tag_name: "meta", attributes: %{property: "article:modified_time", content: updated_at}}
      ]
    )
  end
end
