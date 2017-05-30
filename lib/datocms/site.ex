defmodule DatoCMS.Site do
  require DatoCMS.Client

  def fetch() do
    DatoCMS.start()
    params = %{"include": "item_types,item_types.fields"}
    DatoCMS.Client.Site.get(params)
  end
end
