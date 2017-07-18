defmodule DatoCMS.MetaTag.ArticlePublisher.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{
      attributes: %{
        global_seo: %{
          facebook_page_url: context[:facebook_page_url]
        }
      }
    }

    {:ok, tags} = DatoCMS.MetaTag.ArticlePublisher.build(%{site: site})

    Map.merge(context, %{tags: tags})
  end

  describe "with facebook_page_url unset" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with site_name set" do
    @tag facebook_page_url: "example.com"
    test "it returns an article:publisher tag", %{tags: tags, facebook_page_url: facebook_page_url} do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "article:publisher", content: facebook_page_url}}
        ]
      )
    end
  end
end
