defmodule DatoCMS.Items do
  @page_limit 500

  def fetch do
    DatoCMS.start()
    do_fetch(1) |> handle([], 1, nil)
  end

  defp do_fetch(page) do
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
  defp handle({:error, reason}, _items, _page, _total_pages) do
    {:error, reason}
  end

  defp loop(items, total_pages, total_pages) do
    # Done!
    {:ok, items}
  end
  defp loop(items, page, total_pages) do
    do_fetch(page + 1) |> handle(items, page + 1, total_pages)
  end
end
