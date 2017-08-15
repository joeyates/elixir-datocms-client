defmodule DatoCMS.MetaTag.Image.Test do
  use ExUnit.Case, async: false

  setup context do
    site = %{
      data: %{
        attributes: %{
          global_seo: %{
            fallback_seo: %{
              image: context[:fallback_seo_image]
            }
          },
          imgix_host: "imgix.example.com"
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

  def imgix_url(image) do
    "https://imgix.example.com#{image.path}?auto=compress%2Cformat&ixlib=rb-1.1.0"
  end

  describe "with no image" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with a SEO image" do
    @tag item_seo_image: %{path: "/item_seo_image"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_seo_image)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_seo_image)}}
        ]
      )
    end
  end

  describe "with images" do
    @tag item_image1: %{path: "/item_image1", height: 300, width: 300}
    test "it returns tags based on the first item image", %{
      item_image1: item_image1,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_image1)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_image1)}}
        ]
      )
    end
  end

  describe "with an item image smaller and larger than 200x200" do
    @tag item_image1: %{path: "/item_image1", height: 100, width: 100}
    @tag item_image2: %{path: "/item_image2", height: 300, width: 300}
    test "it returns tags based on the first image bigger than 200x200", %{
      item_image2: item_image2,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_image2)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_image2)}}
        ]
      )
    end
  end

  describe "with an item image and SEO image" do
    @tag item_seo_image: %{path: "SEO Title"}
    @tag item_image1: %{path: "/item_image1", height: 300, width: 300}
    test "it returns tags based on the item SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_seo_image)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_seo_image)}}
        ]
      )
    end
  end

  describe "with fallback SEO" do
    @tag fallback_seo_image: %{path: "/Fallback SEO"}
    test "it returns an empty list", %{
      fallback_seo_image: fallback_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(fallback_seo_image)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(fallback_seo_image)}}
        ]
      )
    end
  end

  describe "with a SEO image and fallback SEO" do
    @tag fallback_seo_image: %{path: "/Fallback SEO"}
    @tag item_seo_image: %{path: "/SEO Title"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_seo_image)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_seo_image)}}
        ]
      )
    end
  end

  describe "with an item image and fallback image" do
    @tag fallback_seo_image: %{path: "/Fallback SEO"}
    @tag item_image1: %{path: "/item_image1", height: 300, width: 300}
    test "it returns tags based on the item image", %{
      item_image1: item_image1,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_image1)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_image1)}}
        ]
      )
    end
  end

  describe "with a SEO image, an image and a fallback image" do
    @tag fallback_seo_image: %{path: "/Fallback SEO"}
    @tag item_seo_image: %{path: "/SEO Title"}
    test "it returns tags based on the SEO image", %{
      item_seo_image: item_seo_image,
      tags: tags
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:image", content: imgix_url(item_seo_image)}},
          %{tag_name: "meta", attributes: %{name: "twitter:image", content: imgix_url(item_seo_image)}}
        ]
      )
    end
  end
end
