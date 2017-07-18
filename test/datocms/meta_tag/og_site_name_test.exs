defmodule DatoCMS.MetaTag.OgSiteName.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{attributes: %{global_seo: %{site_name: context[:site_name]}}}

    {:ok, tags} = DatoCMS.MetaTag.OgSiteName.build(%{site: site})

    Map.merge(context, %{tags: tags})
  end

  describe "with site_name unset" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with site_name set" do
    @tag site_name: "My Site"
    test "it returns a site_name tag", %{tags: tags, site_name: site_name} do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{property: "og:site_name", content: site_name}}
        ]
      )
    end
  end
end
