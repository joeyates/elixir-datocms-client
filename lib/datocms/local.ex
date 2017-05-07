defmodule DatoCMS.Local do
  @page_limit 500

  def site do
    DatoCMS.start()
    params = %{"include": "item_types,item_types.fields"}
    DatoCMS.Site.Site.get(params)
  end

  def items do
    DatoCMS.start()
    fetch(1) |> handle([], 1, nil)
  end

  defp fetch(page) do
    offset = @page_limit * (page - 1)
    params = %{"page[limit]": @page_limit, "page[offset]": offset}
    DatoCMS.Site.Item.index(params)
  end

  defp handle({:ok, response}, [], 1, nil) do
    # First time
    total_count = response["meta"]["total_count"]
    total_pages = round(Float.ceil(total_count / @page_limit))
    data = response["data"]
    loop(data, 1, total_pages)
  end
  defp handle({:ok, response}, items, page, total_pages) do
    data = response["data"]
    loop(items ++ data, page, total_pages)
  end

  defp loop(items, total_pages, total_pages) do
    # Done!
    items
  end
  defp loop(items, page, total_pages) do
    fetch(page + 1) |> handle(items, page + 1, total_pages)
  end
end
