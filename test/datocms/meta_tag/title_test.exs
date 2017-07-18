defmodule DatoCMS.MetaTag.Title.Test do
  use ExUnit.Case, async: true

  setup context do
    title_suffix = " - Title Suffix"
    site = %{
      attributes: %{
        global_seo: %{
          title_suffix: title_suffix,
          fallback_seo: %{
            title: context[:fallback_seo_title]
          }
        }
      }
    }

    item_type = %{
      fields: [
        %{
          attributes: %{
            api_key: "title",
            field_type: "string",
            appeareance: %{
              type: "title"
            }
          }
        }
      ]
    }

    item_title = context[:item_title]
    item = %{
      seo: %{title: context[:item_seo_title]},
      title: item_title
    }

    item_title_with_suffix = "#{item_title}#{title_suffix}"

    {:ok, tags} = DatoCMS.MetaTag.Title.build(%{site: site, item_type: item_type, item: item})

    Map.merge(context, %{tags: tags, item_title_with_suffix: item_title_with_suffix})
  end

  describe "with no title" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with a SEO title" do
    @tag item_seo_title: "SEO Title"
    test "it returns tags based on the SEO title", %{
      item_seo_title: item_seo_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_seo_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_seo_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_seo_title}}
        ]
      )
    end
  end

  describe "with an item title" do
    @tag item_title: "Item Title"
    test "it returns tags based on the item title", %{
      item_title: item_title,
      item_title_with_suffix: item_title_with_suffix,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_title_with_suffix},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_title}}
        ]
      )
    end
  end

  describe "with a long item title" do
    @tag global_title_suffix: " - Suffix"
    @tag item_title: String.duplicate("Item Title longer than 60 characters", 4)
    test "it doesn't add the title suffix", %{
      item_title: item_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_title}}
        ]
      )
    end
  end

  describe "with an item title and SEO title" do
    @tag item_seo_title: "SEO Title"
    @tag item_title: "Item Title"
    test "it returns tags based on the item SEO title", %{
      item_seo_title: item_seo_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_seo_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_seo_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_seo_title}}
        ]
      )
    end
  end

  describe "with fallback SEO" do
    @tag fallback_seo_title: "Fallback SEO"
    test "it returns an empty list", %{
      fallback_seo_title: fallback_seo_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: fallback_seo_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: fallback_seo_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: fallback_seo_title}}
        ]
      )
    end
  end

  describe "with a SEO title and fallback SEO" do
    @tag fallback_seo_title: "Fallback SEO"
    @tag item_seo_title: "SEO Title"
    test "it returns tags based on the SEO title", %{
      item_seo_title: item_seo_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_seo_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_seo_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_seo_title}}
        ]
      )
    end
  end

  describe "with an item title and fallback title" do
    @tag fallback_seo_title: "Fallback SEO"
    @tag item_title: "Item Title"
    test "it returns tags based on the item title", %{
      item_title: item_title,
      item_title_with_suffix: item_title_with_suffix,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_title_with_suffix},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_title}}
        ]
      )
    end
  end

  describe "with a SEO title, a title and a fallback title" do
    @tag fallback_seo_title: "Fallback SEO"
    @tag item_seo_title: "SEO Title"
    test "it returns tags based on the SEO title", %{
      item_seo_title: item_seo_title,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "title", content: item_seo_title},
          %{tag_name: "meta", attributes: %{property: "og:title", content: item_seo_title}},
          %{tag_name: "meta", attributes: %{name: "twitter:title", content: item_seo_title}}
        ]
      )
    end
  end
end
