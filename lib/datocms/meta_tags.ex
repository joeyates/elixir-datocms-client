defmodule DatoCMS.MetaTags do
  @meta_tag_modules [
    DatoCMS.MetaTag.Title,
    DatoCMS.MetaTag.Description,
    DatoCMS.MetaTag.Image,
    DatoCMS.MetaTag.Robots,
    DatoCMS.MetaTag.OgLocale,
    DatoCMS.MetaTag.OgType,
    DatoCMS.MetaTag.OgSiteName,
    DatoCMS.MetaTag.ArticleModifiedTime,
    DatoCMS.MetaTag.ArticlePublisher,
    DatoCMS.MetaTag.TwitterCard,
    DatoCMS.MetaTag.TwitterSite
  ]

  def for_item({type, _id} = specifier, locale) do
    item = item(specifier)
    item_type = item_type(type)
    site = site()
    build_tags(item, item_type, site, locale)
  end
  def for_item(item, locale) do
    type = item.item_type
    item_type = item_type(type)
    site = site()
    build_tags(item, item_type, site, locale)
  end

  defp item(specifier), do: DatoCMS.Repo.get!(specifier)
  defp item_type(type), do: DatoCMS.Repo.item_type!(type)
  defp site(), do: DatoCMS.Repo.site!()

  defp build_tags(item, item_type, site, locale) do
    args = [%{locale: locale, item: item, item_type: item_type, site: site}]
    tags = Enum.map(@meta_tag_modules, fn (module) ->
      {:ok, tags} = apply(module, :build, args)
      tags
    end) |> List.flatten
    {:ok, tags}
  end
end
