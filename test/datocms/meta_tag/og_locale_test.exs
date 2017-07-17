defmodule DatoCMS.MetaTag.OgLocale.Test do
  use ExUnit.Case, async: true

  test "it returns a tag for the locale" do
    {:ok, tags} = DatoCMS.MetaTag.OgLocale.build(%{locale: :en})

    assert(
      tags == [
        %{tag_name: "meta", attributes: %{property: "og:locale", content: "en_EN"}}
      ]
    )
  end
end
