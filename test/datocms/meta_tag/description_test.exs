defmodule DatoCMS.MetaTag.Description.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{
      attributes: %{
        global_seo: %{
          fallback_seo: %{
            description: context[:fallback_seo_description]
          }
        }
      }
    }

    item = %{
      seo: %{description: context[:item_seo_description]}
    }

    {:ok, tags} = DatoCMS.MetaTag.Description.build(%{site: site, item: item})

    Map.merge(context, %{tags: tags})
  end

  describe "with no description" do
    test "it returns an empty list", %{
      tags: tags
    } do

      assert(length(tags) == 0)
    end
  end

  describe "with a SEO description" do
    @tag item_seo_description: "SEO description"
    test "it returns tags based on the SEO description", %{
      item_seo_description: item_seo_description,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{name: "description", content: item_seo_description}},
          %{tag_name: "meta", attributes: %{property: "og:description", content: item_seo_description}},
          %{tag_name: "meta", attributes: %{name: "twitter:description", content: item_seo_description}}
        ]
      )
    end
  end

  describe "with fallback SEO" do
    @tag fallback_seo_description: "Fallback SEO"
    test "it returns an empty list", %{
      fallback_seo_description: fallback_seo_description,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{name: "description", content: fallback_seo_description}},
          %{tag_name: "meta", attributes: %{property: "og:description", content: fallback_seo_description}},
          %{tag_name: "meta", attributes: %{name: "twitter:description", content: fallback_seo_description}}
        ]
      )
    end
  end

  describe "with a SEO description and fallback SEO" do
    @tag fallback_seo_description: "Fallback SEO"
    @tag item_seo_description: "SEO description"
    test "it returns tags based on the SEO description", %{
      item_seo_description: item_seo_description,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{name: "description", content: item_seo_description}},
          %{tag_name: "meta", attributes: %{property: "og:description", content: item_seo_description}},
          %{tag_name: "meta", attributes: %{name: "twitter:description", content: item_seo_description}}
        ]
      )
    end
  end
end
