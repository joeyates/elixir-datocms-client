defmodule DatoCMS.MetaTag.Image.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{
      attributes: %{
        global_seo: %{
          fallback_seo: %{
            image: context[:fallback_seo_image]
          }
        }
      }
    }

    item_type = %{
      fields: [
        %{
          attributes: %{
            api_key: "image1",
            field_type: "image"
          }
        },
        %{
          attributes: %{
            api_key: "image2",
            field_type: "image"
          }
        }
      ]
    }

    item = %{
      seo: %{image: context[:item_seo_image]},
      image1: context[:item_image1],
      image2: context[:item_image2]
    }

    {:ok, tags} = DatoCMS.MetaTag.Image.build(%{site: site, item_type: item_type, item: item})

    Map.merge(context, %{tags: tags})
  end

  describe "with no image" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with a SEO image" do
    @tag item_seo_image: %{url: "item_seo_image"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_seo_image.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_seo_image.url}}
        ]
      )
    end
  end

  describe "with images" do
    @tag item_image1: %{url: "item_image1", height: 300, width: 300}
    test "it returns tags based on the first item image", %{
      item_image1: item_image1,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_image1.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_image1.url}}
        ]
      )
    end
  end

  describe "with an item image smaller and larger than 200x200" do
    @tag item_image1: %{url: "item_image1", height: 100, width: 100}
    @tag item_image2: %{url: "item_image2", height: 300, width: 300}
    test "it returns tags based on the first image bigger than 200x200", %{
      item_image2: item_image2,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_image2.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_image2.url}}
        ]
      )
    end
  end

  describe "with an item image and SEO image" do
    @tag item_seo_image: %{url: "SEO Title"}
    @tag item_image1: %{url: "item_image1", height: 300, width: 300}
    test "it returns tags based on the item SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_seo_image.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_seo_image.url}}
        ]
      )
    end
  end

  describe "with fallback SEO" do
    @tag fallback_seo_image: %{url: "Fallback SEO"}
    test "it returns an empty list", %{
      fallback_seo_image: fallback_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: fallback_seo_image.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: fallback_seo_image.url}}
        ]
      )
    end
  end

  describe "with a SEO image and fallback SEO" do
    @tag fallback_seo_image: %{url: "Fallback SEO"}
    @tag item_seo_image: %{url: "SEO Title"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_seo_image.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_seo_image.url}}
        ]
      )
    end
  end

  describe "with an item image and fallback image" do
    @tag fallback_seo_image: %{url: "Fallback SEO"}
    @tag item_image1: %{url: "item_image1", height: 300, width: 300}
    test "it returns tags based on the item image", %{
      item_image1: item_image1,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_image1.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_image1.url}}
        ]
      )
    end
  end

  describe "with a SEO image, an image and a fallback image" do
    @tag fallback_seo_image: %{url: "Fallback SEO"}
    @tag item_seo_image: %{url: "SEO Title"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: item_seo_image.url}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: item_seo_image.url}}
        ]
      )
    end
  end
end
