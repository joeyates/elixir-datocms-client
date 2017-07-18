defmodule DatoCMS.MetaTag.TwitterCard.Test do
  use ExUnit.Case, async: true

  test "it returns a Twitter summary tag" do
    {:ok, tags} = DatoCMS.MetaTag.TwitterCard.build(%{})

    assert(
      tags == [
        %{tag_name: "meta", attributes: %{name: "twitter:card", content: "summary"}}
      ]
    )
  end
end
