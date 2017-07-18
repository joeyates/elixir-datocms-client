defmodule DatoCMS.MetaTag.TwitterSite.Test do
  use ExUnit.Case, async: true

  setup context do
    site = %{
      attributes: %{
        global_seo: %{
          twitter_account: context[:twitter_account]
        }
      }
    }

    {:ok, tags} = DatoCMS.MetaTag.TwitterSite.build(%{site: site})

    Map.merge(context, %{tags: tags})
  end

  describe "with twitter_account unset" do
    test "it returns an empty list", %{tags: tags} do
      assert(length(tags) == 0)
    end
  end

  describe "with twitter_account set" do
    @tag twitter_account: "foo"
    test "it returns a twitter:site tag", %{
      tags: tags, twitter_account: twitter_account
    } do
      assert(
        tags == [
          %{tag_name: "meta", attributes: %{name: "twitter:site", content: twitter_account}}
        ]
      )
    end
  end
end
