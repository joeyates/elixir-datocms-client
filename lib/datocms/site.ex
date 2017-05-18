defmodule DatoCMS.Site do
  def fetch do
    DatoCMS.start()
    params = %{"include": "item_types,item_types.fields"}
    DatoCMS.Site.Site.get(params)
  end
end
