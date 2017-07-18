defmodule DatoCMS.MetaTag.TwitterSite do
  import DatoCMS.MetaTag.Helpers

  def build(%{site: site}) do
    twitter_account(site) |> handle_twitter_account
  end

  defp handle_twitter_account(nil) do
    {:ok, []}
  end
  defp handle_twitter_account(twitter_account) do
    {:ok, [card_tag("twitter:site", twitter_account)]}
  end

  defp twitter_account(%{attributes: %{global_seo: %{twitter_account: twitter_account}}}) do
    twitter_account
  end
  defp twitter_account(_site), do: nil
end
