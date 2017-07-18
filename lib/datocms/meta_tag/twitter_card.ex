defmodule DatoCMS.MetaTag.TwitterCard do
  import DatoCMS.MetaTag.Helpers

  def build(%{}) do
    {:ok, [card_tag("twitter:card", "summary")]}
  end
end
